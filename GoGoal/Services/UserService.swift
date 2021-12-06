//
//  UserService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

class UserService: BaseRepository<User> {
  
  static let shared = UserService()
  
  private static let DEFAULT_AVATAR: String = "default_user_avatar"
  
  let storage = FileStorage(.users)
  
  init() {
    let rootRef = Firestore.firestore().collection(.users)
    super.init(rootRef)
  }
  
  private func loadAvatar(_ user: User, _ completion: @escaping (User) -> Void) {
    var user = user
    
    guard let path = user.avatarPath else {
      user.avatar = UIImage(named: UserService.DEFAULT_AVATAR)
      completion(user)
      return
    }
    
    storage.downloadFile(fullPath: path) { data in
      user.avatar = UIImage.fromData(data: data)
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
  
  override func queryByFields(queries: [QueryCondition], orders: [OrderCondition]? = nil, limit: Int? = nil,
                              _ completion: @escaping ([User]) -> Void) {
    super.queryByFields(queries: queries, orders: orders, limit: limit) { userList in
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
  
  func getByEmail(email: String, _ completion: @escaping (User?) -> Void) {
    let query = QueryCondition(field: "email", predicate: .equal, value: email)
    
    queryByFields(queries: [query]) { userList in
      let user = userList.count == 0 ? nil : userList[0]
      completion(user)
    }
  }
  
  func setAvatar(user: User, image: UIImage, _ completion: @escaping () -> Void = {}) {
    guard let data = image.pngData() else {
      return
    }
    
    storage.uploadFile(subPath: user.id!, file: data, type: .image) { path in
      var user = user
      user.avatarPath = path
      user.lastUpdateDate = Timestamp.init()
      self.createOrUpdate(object: user) { completion() }
    }
  }
  
}
