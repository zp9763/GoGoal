//
//  UserService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore
import SwiftUI

class UserService: BaseRepository<User> {
  
  private static let DEFAULT_AVATAR = "default_avatar"
  
  let storage = FileStorage(.users)
  
  init() {
    let rootRef = Firestore.firestore().collection(.users)
    super.init(rootRef)
  }
  
  private func loadAvatar(_ user: User, _ completion: @escaping (User) -> Void) {
    var user = user
    
    guard let path = user.avatarPath else {
      let uiImage = UIImage(named: UserService.DEFAULT_AVATAR)
      user.avatar = Image.fromUIImage(uiImage: uiImage)
      
      completion(user)
      return
    }
    
    storage.downloadFile(fullPath: path) { data in
      user.avatar = Image.fromData(data: data)
      completion(user)
    }
  }
  
  override func getAll(_ completion: @escaping ([User]) -> Void) {
    super.getAll() { userList in
      var userList = userList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<userList.count {
        dispatchGroup.enter()
        self.loadAvatar(userList[i]) { user in
          userList[i].avatar = user.avatar
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(userList) }
    }
  }
  
  override func getById(id: String, _ completion: @escaping (User?) -> Void) {
    super.getById(id: id) { user in
      if let user = user {
        self.loadAvatar(user) { completion($0) }
      } else {
        completion(nil)
      }
    }
  }
  
  override func queryByFields(_ conditions: [QueryCondition], _ completion: @escaping ([User]) -> Void) {
    super.queryByFields(conditions) { userList in
      var userList = userList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<userList.count {
        dispatchGroup.enter()
        self.loadAvatar(userList[i]) { user in
          userList[i] = user
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(userList) }
    }
  }
  
  func setAvatar(user: User, image: UIImage) {
    guard let data = image.pngData() else {
      return
    }
    
    storage.uploadFile(subPath: user.id!, file: data, type: .image) { path in
      var user = user
      user.avatarPath = path
      self.createOrUpdate(object: user)
    }
  }
  
}
