//
//  PostService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class PostService: BaseRepository<Post> {
  
  init() {
    let rootRef = Firestore.firestore().collection(.posts)
    super.init(rootRef)
  }
  
  private func loadPostLikes(_ post: Post, _ completion: @escaping (Post) -> Void) {
    var post = post
    let likeRef = self.rootRef.document(post.id!).collection(.likes)
    let likeService = LikeService(likeRef)
    
    likeService.getAll() { likeList in
      if likeList.count == 0 {
        completion(post)
      } else {
        post.likes = [String: Timestamp]()
        for like in likeList {
          post.likes![like.id!] = like.createDate
        }
        completion(post)
      }
    }
  }
  
  override func getAll(_ completion: @escaping ([Post]) -> Void) {
    super.getAll() { postList in
      var postList = postList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<postList.count {
        dispatchGroup.enter()
        self.loadPostLikes(postList[i]) { post in
          postList[i] = post
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(postList) }
    }
  }
  
  override func getById(id: String, _ completion: @escaping (Post?) -> Void) {
    super.getById(id: id) { post in
      if let post = post {
        self.loadPostLikes(post) { completion($0) }
      } else {
        completion(nil)
      }
    }
  }
  
  override func queryByFields(_ conditions: [QueryCondition], _ completion: @escaping ([Post]) -> Void) {
    super.queryByFields(conditions) { postList in
      var postList = postList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<postList.count {
        dispatchGroup.enter()
        self.loadPostLikes(postList[i]) { post in
          postList[i] = post
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(postList) }
    }
  }
  
  func getByGoalId(goalId: String, _ completion: @escaping ([Post]) -> Void) {
    let condition = QueryCondition(field: "goalId", predicate: .equal, value: goalId)
    queryByFields([condition], completion)
  }
  
  func getByTopicIds(topicIds: [String], _ completion: @escaping ([Post]) -> Void) {
    let condition = QueryCondition(field: "topicId", predicate: .isIn, value: topicIds)
    queryByFields([condition], completion)
  }
  
  func addUserLike(postId: String, userId: String) {
    let likeRef = self.rootRef.document(postId).collection(.likes)
    let likeService = LikeService(likeRef)
    likeService.createOrUpdate(object: Like(id: userId))
  }
  
  func removeUserLike(postId: String, userId: String) {
    let likeRef = self.rootRef.document(postId).collection(.likes)
    let likeService = LikeService(likeRef)
    likeService.deleteById(id: userId)
  }
  
}
