//
//  GoalService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class GoalService: BaseRepository<Goal> {
  
  private static let COMPLETED_GOAL_QUERY_LIMIT: Int = 50
  
  let postService = PostService()
  
  init() {
    let rootRef = Firestore.firestore().collection(.goals)
    super.init(rootRef)
  }
  
  func getByUserId(userId: String, _ completion: @escaping ([Goal]) -> Void) {
    let query = QueryCondition(field: "userId", predicate: .equal, value: userId)
    queryByFields(queries: [query], completion)
  }
  
  func getCompletedByTopicIds(topicIds: [String], _ completion: @escaping ([Goal]) -> Void) {
    // `isIn` query requires a non-empty array
    guard topicIds.count > 0 else {
      completion([])
      return
    }
    
    let queries = [
      QueryCondition(field: "topicId", predicate: .isIn, value: topicIds),
      QueryCondition(field: "isCompleted", predicate: .equal, value: true)
    ]
    
    let order = OrderCondition(field: "lastUpdateDate", descending: true)
    
    queryByFields(queries: queries, orders: [order], limit: GoalService.COMPLETED_GOAL_QUERY_LIMIT, completion)
  }
  
  func deleteGoalCascade(goal: Goal, _ completion: @escaping () -> Void = {}) {
    self.deleteById(id: goal.id!) {
      self.postService.getByGoalId(goalId: goal.id!) { postList in
        let dispatchGroup = DispatchGroup()
        
        for post in postList {
          dispatchGroup.enter()
          self.postService.removePhotos(post: post) {
            dispatchGroup.leave()
          }
          
          dispatchGroup.enter()
          self.postService.deleteById(id: post.id!) {
            dispatchGroup.leave()
          }
        }
        
        dispatchGroup.notify(queue: .main) { completion() }
      }
    }
  }
  
}
