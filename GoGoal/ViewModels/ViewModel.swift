//
//  ViewModel.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import Foundation

class ViewModel: ObservableObject {
  
  @Published var user: User
  @Published var userGoals = [Goal]()
  
  init(user: User) {
    self.user = user
  }
  
}
