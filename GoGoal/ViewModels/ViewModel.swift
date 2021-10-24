//
//  ViewModel.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import Foundation

class ViewModel: ObservableObject {
  
  @Published var user: User
  @Published var goalDict = [String: Goal]()
  
  init(user: User) {
    self.user = user
  }
  
  private let userService = UserService()
  private let goalService = GoalService()
  
  func fetchUserGoals() {
    goalService.getByUserId(userId: user.id!) { goalList in
      for goal in goalList {
        self.goalDict[goal.id!] = goal
      }
      print(self.goalDict)
    }
  }
  
}
