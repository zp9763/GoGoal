//
//  GoalService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class GoalService: BaseRepository<Goal> {
  
  let db: Firestore
  
  init() {
    db = Firestore.firestore()
    super.init(db.collection(.goals))
  }
  
  func getByUserId(userId: String, _ completion: @escaping ([Goal]) -> Void) {
    let conditions = [QueryCondition(field: "userId", predicate: .equal, value: userId)]
    queryByFields(conditions, completion)
  }
}
