//
//  TopicService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class TopicService: BaseRepository<Topic> {
  
  let db: Firestore
  
  init() {
    db = Firestore.firestore()
    super.init(db.collection(.topics))
  }
  
  func getByName(name: String, _ completion: @escaping ([Topic]) -> Void) {
    let conditions = [QueryCondition(field: "name", predicate: .equal, value: name)]
    queryByFields(conditions, completion)
  }
}
