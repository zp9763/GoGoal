//
//  GenSampleData.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

class GenSampleData {
  
  static let userService = UserService()
  static let topicService = TopicService()
  static let goalService = GoalService()
  static let postService = PostService()
  
  static let user = User(
    email: "testuser@example.com",
    firstName: "Test",
    lastName: "User"
  )
  
  static func setUp() {
    topicService.getByName(name: "Sports") { topic in
      userService.createOrUpdate(object: user)
      
      var goals = [
        Goal(userId: user.id!,
             topicId: topic!.id!,
             title: "play footbal",
             description: "play footbal every Friday",
             duration: 10),
        Goal(userId: user.id!,
             topicId: topic!.id!,
             title: "play basketball",
             description: "play basketball every Sunday",
             duration: 20),
        Goal(userId: user.id!,
             topicId: topic!.id!,
             title: "go swimming",
             description: "go swimming every Tuesday",
             duration: 30)
      ]
      
      for goal in goals {
        goalService.createOrUpdate(object: goal)
      }
      
      let posts = [
        Post(userId: user.id!,
             goalId: goals[0].id!,
             topicId: topic!.id!,
             content: "Today I played football with David"),
        Post(userId: user.id!,
             goalId: goals[0].id!,
             topicId: topic!.id!,
             content: "Today I played football with Mike"),
        Post(userId: user.id!,
             goalId: goals[1].id!,
             topicId: topic!.id!,
             content: "Today I played basketball with John")
      ]
      
      for post in posts {
        postService.createOrUpdate(object: post)
      }
      
      goals[0].checkInDates = [posts[0].createDate, posts[1].createDate]
      goals[1].checkInDates = [posts[2].createDate]
      
      goalService.createOrUpdate(object: goals[0])
      goalService.createOrUpdate(object: goals[1])
      
      postService.addUserLike(postId: posts[0].id!, userId: user.id!)
      postService.addUserLike(postId: posts[2].id!, userId: user.id!)
    }
  }
  
  static func printInfo() {
    goalService.getByUserId(userId: user.id!) { goalList in
      for goal in goalList {
        goalList.forEach() { print($0); print() }
        postService.getByGoalId(goalId: goal.id!) { postList in
          postList.forEach() { print($0); print() }
        }
      }
    }
  }
  
}
