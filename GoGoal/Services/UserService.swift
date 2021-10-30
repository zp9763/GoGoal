//
//  UserService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

class UserService: BaseRepository<User> {
    
  init() {
    let rootRef = Firestore.firestore().collection(.users)
    super.init(rootRef)
  }
  
}
