//
//  PostService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class PostService: BaseRepository<Post> {
  
  private static let RECENT_POST_QUERY_LIMIT: Int = 100
  
  let storage = FileStorage(.posts)
  
  init() {
    let rootRef = Firestore.firestore().collection(.posts)
    super.init(rootRef)
  }
  
  private func loadPostLikes(_ post: Post, _ completion: @escaping (Post) -> Void) {
    let likeRef = self.rootRef.document(post.id!).collection(.likes)
    let likeService = LikeService(likeRef)
    
    likeService.getAll() { likeList in
      guard likeList.count > 0 else {
        completion(post)
        return
      }
      
      var post = post
      post.likes = [String: Timestamp]()
      for like in likeList {
        post.likes![like.id!] = like.createDate
      }
      completion(post)
    }
  }
  
  private func loadPostPhotos(_ post: Post, _ completion: @escaping (Post) -> Void) {
    guard let path = post.photosPath else {
      completion(post)
      return
    }
    
    storage.downloadFolderFiles(fullPath: path) { dataList in
      var post = post
      post.photos = dataList
        .sorted() { $0.count < $1.count }  // avoid random image sequence
        .map() { UIImage(data: $0) }
        .compactMap() { $0 }
      completion(post)
    }
  }
  
  override func getAll(_ completion: @escaping ([Post]) -> Void) {
    super.getAll() { postList in
      var postList = postList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<postList.count {
        dispatchGroup.enter()
        self.loadPostLikes(postList[i]) { post in
          postList[i].likes = post.likes
          dispatchGroup.leave()
        }
      }
      
      for i in 0..<postList.count {
        dispatchGroup.enter()
        self.loadPostPhotos(postList[i]) { post in
          postList[i].photos = post.photos
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(postList) }
    }
  }
  
  override func getById(id: String, _ completion: @escaping (Post?) -> Void) {
    super.getById(id: id) { post in
      guard var post = post else {
        completion(nil)
        return
      }
      
      let dispatchGroup = DispatchGroup()
      
      dispatchGroup.enter()
      self.loadPostLikes(post) {
        post.likes = $0.likes
        dispatchGroup.leave()
      }
      
      dispatchGroup.enter()
      self.loadPostPhotos(post) {
        post.photos = $0.photos
        dispatchGroup.leave()
      }
      
      dispatchGroup.notify(queue: .main) { completion(post) }
    }
  }
  
  override func queryByFields(queries: [QueryCondition], orders: [OrderCondition]? = nil, limit: Int? = nil,
                              _ completion: @escaping ([Post]) -> Void) {
    super.queryByFields(queries: queries, orders: orders, limit: limit) { postList in
      var postList = postList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<postList.count {
        dispatchGroup.enter()
        self.loadPostLikes(postList[i]) { post in
          postList[i].likes = post.likes
          dispatchGroup.leave()
        }
      }
      
      for i in 0..<postList.count {
        dispatchGroup.enter()
        self.loadPostPhotos(postList[i]) { post in
          postList[i].photos = post.photos
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(postList) }
    }
  }
  
  override func deleteById(id: String, _ completion: @escaping () -> Void = {}) {
    let likeRef = self.rootRef.document(id).collection(.likes)
    
    likeRef.getDocuments() { (snapshot, err) in
      if let err = err {
        print("Error get documents: \(err)")
        return
      }
      
      let dispatchGroup = DispatchGroup()
      
      for document in snapshot!.documents {
        dispatchGroup.enter()
        document.reference.delete() {_ in
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) {
        super.deleteById(id: id) { completion() }
      }
    }
  }
  
  func getByGoalId(goalId: String, _ completion: @escaping ([Post]) -> Void) {
    let query = QueryCondition(field: "goalId", predicate: .equal, value: goalId)
    queryByFields(queries: [query], completion)
  }
  
  func getRecentByTopicIds(topicIds: [String], _ completion: @escaping ([Post]) -> Void) {
    // `isIn` query requires a non-empty array
    guard topicIds.count > 0 else {
      completion([])
      return
    }
    
    let query = QueryCondition(field: "topicId", predicate: .isIn, value: topicIds)
    let order = OrderCondition(field: "createDate", descending: true)
    
    queryByFields(queries: [query], orders: [order], limit: PostService.RECENT_POST_QUERY_LIMIT, completion)
  }
  
  func addUserLike(postId: String, userId: String, _ completion: @escaping () -> Void = {}) {
    let likeRef = self.rootRef.document(postId).collection(.likes)
    let likeService = LikeService(likeRef)
    likeService.createOrUpdate(object: Like(id: userId)) { completion() }
  }
  
  func removeUserLike(postId: String, userId: String, _ completion: @escaping () -> Void = {}) {
    let likeRef = self.rootRef.document(postId).collection(.likes)
    let likeService = LikeService(likeRef)
    likeService.deleteById(id: userId) { completion() }
  }
  
  func addPhotos(post: Post, images: [UIImage], _ completion: @escaping () -> Void = {}) {
    let dataList = images
      .map() { $0.pngData() }
      .compactMap() { $0 }
    
    storage.uploadFolderFiles(subPath: post.id!, files: dataList, type: .image) { path in
      var post = post
      post.photosPath = path
      self.createOrUpdate(object: post) { completion() }
    }
  }
  
  func removePhotos(post: Post, _ completion: @escaping () -> Void = {}) {
    if let path = post.photosPath {
      storage.deleteFolderFiles(fullPath: path) { completion() }
    } else {
      completion()
    }
  }
  
}
