//
//  LikeService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class LikeService: BaseRepository<Like> {
  
  let db: Firestore
  
  // TODO: change the like collection reference to a sub path under post document
  init() {
    db = Firestore.firestore()
    super.init(db.collection(.likes))
  }
  
}
