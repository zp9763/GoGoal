//
//  UserGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct UserGoalView: View {
  
  @ObservedObject var userModel: UserModel
  
  // display in-progress goals by default
  @State var displayInProgress = true
  @State var displayedGoals = [Goal]()
  
  let goalService = GoalService()
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        
        List {
          ForEach(self.displayedGoals) { goal in
            NavigationLink(destination: GoalProgressView(user: self.userModel.user, goal: goal)) {
              UserGoalRowView(goal: goal)
            }
            // fix SwiftUI bug: nested NavigationLink fails on 2nd click
            .isDetailLink(false)
          }
        }
        
        Spacer()
        
        HStack {
          Spacer()
          
          Button(action: {
            self.displayInProgress = false
            self.updateDisplayedGoals()
          }) {
            Text("Completed")
          }
          
          Spacer()
          
          Button(action: {
            self.displayInProgress = true
            self.updateDisplayedGoals()
          }) {
            Text("In-Progress")
          }
          
          Spacer()
        }
        
        Spacer()
      }
      .navigationBarTitle("Goals", displayMode: .inline)
      .navigationBarItems(
        leading: Menu(content: {
          Button(action: {
            self.displayedGoals = self.displayedGoals
              .sorted() { $0.lastUpdateDate > $1.lastUpdateDate }
          }) {
            Text("Sort by Time")
          }
          
          Button(action: {
            self.displayedGoals = self.displayedGoals
              .sorted() { $0.title < $1.title }
          }) {
            Text("Sort by Title")
          }
          
          Button(action: {
            self.displayedGoals = self.displayedGoals
              .sorted() { $0.duration < $1.duration }
          }) {
            Text("Sort by Duration")
          }
        }) {
          Image(systemName: "equal.circle")
        },
        
        trailing: NavigationLink(destination: EditGoalView(user: self.userModel.user)) {
          Image(systemName: "plus")
        }
      )
      .onAppear(perform: self.fetchAllUserGoals)
    }
  }
  
  func fetchAllUserGoals() {
    self.goalService.getByUserId(userId: self.userModel.user.id!) {
      self.userModel.userGoals = $0
      self.updateDisplayedGoals()
    }
  }
  
  func updateDisplayedGoals() {
    self.displayedGoals = self.userModel.userGoals
      .filter() { $0.isCompleted != self.displayInProgress }
      .sorted() { $0.lastUpdateDate > $1.lastUpdateDate }
  }
  
}
