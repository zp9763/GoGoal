//
//  GoalViewModel.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/15/21.
//

import Foundation
import SwiftUI

class GoalViewModel: ObservableObject {
  
  @Published var goal: Goal = Goal(userId: "", topicId: "", title: "", duration: -1)
  @Published var topicIcon: Image?
  @Published var posts = [Post]()
  
  @Published var allTopics = [Topic]()
  
  let goalService = GoalService()
  let postService = PostService()
  let topicService = TopicService()
  let userService = UserService()
  
  init(goal: Goal? = nil) {
    if let goal = goal {
      self.goal = goal
    }
  }
  
  func fetchAllGoalPosts() {
    self.postService.getByGoalId(goalId: self.goal.id!) { postList in
      self.posts = postList
        .sorted() { $0.createDate > $1.createDate }
    }
  }
  
  func fetchGoalTopicIcon() {
    self.topicService.getById(id: self.goal.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
  func fetchAllTopics() {
    self.topicService.getAll() { topicList in
      self.allTopics = topicList
        .sorted() { $0.name < $1.name }
    }
  }
  
}
