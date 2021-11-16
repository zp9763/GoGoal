//
//  UserViewModel.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import Foundation

class UserViewModel: ObservableObject {
  
  @Published var user = User(email: "", firstName: "", lastName: "")
  @Published var userGoals = [Goal]()
  
  @Published var allTopics = [Topic]()
  
  let userService = UserService()
  let goalService = GoalService()
  let topicService = TopicService()
  
  func loadUserInfoByEmail(email: String, _ completion: @escaping () -> Void = {}) {
    self.userService.getByEmail(email: email) {
      self.user = $0!
      self.fetchAllUserGoals() { completion() }
    }
  }
  
  func fetchAllTopics() {
    self.topicService.getAll() { topicList in
      self.allTopics = topicList
        .sorted() { $0.name < $1.name }
    }
  }
  
  func fetchAllUserGoals(_ completion: @escaping () -> Void = {}) {
    self.goalService.getByUserId(userId: self.user.id!) {
      self.userGoals = $0
      completion()
    }
  }
  
}
