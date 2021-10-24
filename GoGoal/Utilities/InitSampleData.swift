//
//  InitSampleData.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

class InitSampleData {
  
  static let userService = UserService()
  static let topicService = TopicService()
  static let goalService = GoalService()
  
  static let user = User(
    email: "testuser@example.com",
    firstName: "Test",
    lastName: "User"
  )
  
  static func trigger() {
    var leetCodeTopic: Topic? = nil
    
    topicService.getByName(name: "LeetCode") { topicList in
      leetCodeTopic = topicList[0]
      
      let goals = [
        Goal(userId: user.id!,
             topicId: leetCodeTopic!.id!,
             title: "learn binary search",
             description: "some sentences",
             duration: 10),
        Goal(userId: user.id!,
             topicId: leetCodeTopic!.id!,
             title: "learn priority queue",
             description: "some sentences",
             duration: 20),
        Goal(userId: user.id!,
             topicId: leetCodeTopic!.id!,
             title: "learn BST",
             description: "some sentences",
             duration: 30)
      ]
      
      userService.createOrUpdate(object: user)
      
      for goal in goals {
        goalService.createOrUpdate(object: goal)
      }
    }
  }
  
}
