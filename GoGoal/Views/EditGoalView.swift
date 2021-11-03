//
//  EditGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct EditGoalView: View {
  
  // scenario 1: navigated from user goal page, need to create a new goal
  @State var user: User?
  
  // scenario 2: nagivated from goal progress page, need to edit existing goal
  var goal: Goal?
  
  let userService = UserService()
  
  var body: some View {
    Text("Hello, World!")
      .navigationBarTitle("Edit Goal", displayMode: .inline)
  }
  
  func fetchUserIfNotPassed() {
    if let userId = self.goal?.userId {
      self.userService.getById(id: userId) {
        self.user = $0!
      }
    }
  }
  
}
