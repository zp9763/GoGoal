//
//  UserService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

class UserService {
  
  let db: Firestore
  let rootRef: CollectionReference
  let repo: ModelRepository<User>
  
  init() {
    db = Firestore.firestore()
    rootRef = db.collection(.users)
    repo = ModelRepository(rootRef)
  }
  
  func getAll() -> [User] {
    return repo.getAll()
  }
  
  func getById(id: String) -> User? {
    return repo.getById(id)
  }
  
  func addOrUpdate(user: User) {
    repo.addOrUpdate(user)
  }
  
  func deleteById(id: String) {
    repo.deleteById(id)
  }
  
}
