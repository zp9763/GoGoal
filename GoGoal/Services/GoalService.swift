//
//  GoalService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class GoalService: BaseRepository<Goal> {
    
  init() {
    let rootRef = Firestore.firestore().collection(.goals)
    super.init(rootRef)
  }
  
  func getByUserId(userId: String, _ completion: @escaping ([Goal]) -> Void) {
    let condition = QueryCondition(field: "userId", predicate: .equal, value: userId)
    queryByFields([condition], completion)
  }
  
  func getCompletedByTopicId(topicId: String, _ completion: @escaping ([Goal]) -> Void) {
    let conditions = [
      QueryCondition(field: "topicId", predicate: .equal, value: topicId),
      QueryCondition(field: "isCompleted", predicate: .equal, value: true)
    ]
    queryByFields(conditions, completion)
  }
  
}
