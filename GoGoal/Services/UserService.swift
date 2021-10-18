//
//  UserService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

class UserService: BaseRepository<User> {
  
  let db: Firestore
  
  init() {
    db = Firestore.firestore()
    super.init(db.collection(.users))
  }
  
  func queryByLastName(lastName: String, _ completion: @escaping ([User]) -> Void) {
    let conditions = [
      QueryCondition(field: "lastName", predicate: .equal, value: lastName)
    ]
    queryByFields(conditions, completion)
  }
}
