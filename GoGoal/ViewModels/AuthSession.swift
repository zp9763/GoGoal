//
//  AuthSession.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/14/21.
//

import Foundation

class AuthSession: ObservableObject {
  
  @Published var isLoggedin: Bool = false
  @Published var userModel = UserModel()
  
  func login(userEmail: String) {
    self.userModel.loadUserInfoByEmail(email: userEmail) {
      self.isLoggedin = true
    }
  }
  
  func logout() {
    self.userModel = UserModel()
    self.isLoggedin = false
  }
  
}
