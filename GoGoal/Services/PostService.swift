//
//  PostService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import SwiftUI

class PostService: BaseRepository<Post> {
  
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
        .map() { Image.fromData(data: $0) }
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
  
  override func queryByFields(_ conditions: [QueryCondition], _ completion: @escaping ([Post]) -> Void) {
    super.queryByFields(conditions) { postList in
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
  
  func setPhotos(post: Post, images: [UIImage]) {
    let dataList = images
      .map() { $0.pngData() }
      .compactMap() { $0 }
    
    storage.uploadFolderFiles(subPath: post.id!, files: dataList, type: .image) { path in
      var post = post
      post.photosPath = path
      self.createOrUpdate(object: post)
    }
  }
  
}
