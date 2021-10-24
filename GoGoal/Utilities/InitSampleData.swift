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
  
  static var user = User(
    email: "testuser@example.com",
    firstName: "Test",
    lastName: "User"
  )
  
  static var goals = [Goal]()
  
  static func trigger() {
    var leetCodeTopic: Topic? = nil
    InitSampleData.topicService.getByName(name: "LeetCode") {
      topicList in leetCodeTopic = topicList[0]
    }
    
    InitSampleData.goals = [
      Goal(userId: InitSampleData.user.id!,
           topicId: leetCodeTopic!.id!,
           title: "learn binary search",
           description: "some sentences",
           duration: 10),
      Goal(userId: InitSampleData.user.id!,
           topicId: leetCodeTopic!.id!,
           title: "learn priority queue",
           description: "some sentences",
           duration: 20),
      Goal(userId: InitSampleData.user.id!,
           topicId: leetCodeTopic!.id!,
           title: "learn BST",
           description: "some sentences",
           duration: 30)
    ]
    
    for goal in InitSampleData.goals {
      InitSampleData.goalService.createOrUpdate(object: goal)
    }
  }
  
}
