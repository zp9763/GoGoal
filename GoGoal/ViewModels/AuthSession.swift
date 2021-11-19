//
//  AuthSession.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/14/21.
//

import Foundation
import FirebaseAuth

class AuthSession: ObservableObject {
  
  @Published var isLoggedin: Bool = false
  @Published var userViewModel = UserViewModel()
  
  func login(userEmail: String, _ completion: @escaping () -> Void = {}) {
    self.userViewModel.userService.getByEmail(email: userEmail) {
      if let user = $0 {
        self.userViewModel.user = user
        self.userViewModel.fetchAllUserGoals() {
          self.isLoggedin = true
          completion()
        }
      } else {
        do {
          try Auth.auth().signOut()
        } catch let err {
          print("Error sign out: \(err)")
        }
        
        print("""
        ===========================================
        
        Warning: user auth valid but user not exist!
        
        Possible reasons:
          (1) user was deleted in firestore
          (2) user was active in one env but
              app now deployed in another env
        
        ===========================================
        """)
        
        completion()
      }
    }
  }
  
  func logout() {
    self.userViewModel = UserViewModel()
    self.isLoggedin = false
  }
  
}
