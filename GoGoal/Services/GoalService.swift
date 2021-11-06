//
//  GoalService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class GoalService: BaseRepository<Goal> {
  
  let postService = PostService()
  
  init() {
    let rootRef = Firestore.firestore().collection(.goals)
    super.init(rootRef)
  }
  
  func getByUserId(userId: String, _ completion: @escaping ([Goal]) -> Void) {
    let condition = QueryCondition(field: "userId", predicate: .equal, value: userId)
    queryByFields([condition], completion)
  }
  
  func getCompletedByTopicIds(topicIds: [String], _ completion: @escaping ([Goal]) -> Void) {
    // `isIn` query requires a non-empty array
    guard topicIds.count > 0 else {
      completion([])
      return
    }
    
    let conditions = [
      QueryCondition(field: "topicId", predicate: .isIn, value: topicIds),
      QueryCondition(field: "isCompleted", predicate: .equal, value: true)
    ]
    queryByFields(conditions, completion)
  }
  
  func deleteGoalCascade(goal: Goal) {
    self.deleteById(id: goal.id!)
    self.postService.getByGoalId(goalId: goal.id!) { postList in
      for post in postList {
        self.postService.removePhotos(post: post)
        self.postService.deleteById(id: post.id!)
      }
    }
  }
  
}
