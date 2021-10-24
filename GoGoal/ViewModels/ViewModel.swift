//
//  ViewModel.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import Foundation

class ViewModel: ObservableObject {
  
  @Published var user: User
  @Published var goalList = [Goal]()
  
  private let userService = UserService()
  private let goalService = GoalService()
  
  init(user: User) {
    self.user = user
  }
  
  func fetchUserGoals() {
    goalService.getByUserId(userId: user.id!) { goalList in
      self.goalList = goalList
    }
  }
  
}
