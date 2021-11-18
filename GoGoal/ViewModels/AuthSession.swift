//
//  AuthSession.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/14/21.
//

import Foundation

class AuthSession: ObservableObject {
  
  @Published var isLoggedin: Bool = false
  @Published var userViewModel = UserViewModel()
  
  func login(userEmail: String, _ completion: @escaping () -> Void = {}) {
    self.userViewModel.loadUserInfoByEmail(email: userEmail) {
      self.isLoggedin = true
      completion()
    }
  }
  
  func logout() {
    self.userViewModel = UserViewModel()
    self.isLoggedin = false
  }
  
}
