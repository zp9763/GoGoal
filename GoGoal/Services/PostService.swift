//
//  PostService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class PostService: BaseRepository<Post> {
  
  let db: Firestore
  
  init() {
    db = Firestore.firestore()
    super.init(db.collection(.posts))
  }
  
  private func loadPostLikes(_ post: Post, _ completion: @escaping (Post) -> Void) {
    var post = post
    post.likes = [String: Like]()
    
    let likeRef = self.rootRef.document(post.id!).collection(.likes)
    let likeService = LikeService(likeRef)
    
    likeService.getAll() { likeList in
      for like in likeList {
        post.likes![like.id!] = like
      }
      completion(post)
    }
  }
  
  private func unloadPostLikes(_ post: Post) -> Post {
    var post = post
    post.likes = nil
    return post
  }
  
  override func getAll(_ completion: @escaping ([Post]) -> Void) {
    super.getAll() { postList in
      var postList = postList
      
      for i in 0..<postList.count {
        self.loadPostLikes(postList[i]) { post in
          postList[i] = post
        }
      }
      
      completion(postList)
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
  
  override func createOrUpdate(object: Post) {
    super.createOrUpdate(object: self.unloadPostLikes(object))
  }
  
  override func queryByFields(_ conditions: [QueryCondition], _ completion: @escaping ([Post]) -> Void) {
    super.queryByFields(conditions) { postList in
      var postList = postList
      
      for i in 0..<postList.count {
        self.loadPostLikes(postList[i]) { post in
          postList[i] = post
        }
      }
      
      completion(postList)
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
