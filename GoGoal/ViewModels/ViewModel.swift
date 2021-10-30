//
//  ViewModel.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import Foundation

class ViewModel: ObservableObject {
  
  @Published var topicList = [Topic]()
  @Published var user: User
  @Published var goalList = [Goal]()
  
  private let topicService = TopicService()
  private let userService = UserService()
  private let goalService = GoalService()
  
  init(user: User) {
    self.user = user
  }
  
  func fetchAllGoalsByUser() {
    goalService.getByUserId(userId: user.id!) {
      self.goalList = $0
    }
  }
  
  func fetchAllTopics() {
    topicService.getAll() {
      self.topicList = $0
    }
  }
  
}
