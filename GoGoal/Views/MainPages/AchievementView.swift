//
//  AchievementView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct AchievementView: View {
  
  @ObservedObject var userViewModel: UserViewModel
  
  @State var displayedGoals = [Goal]()
  
  let goalService = GoalService()
  
  var body: some View {
    NavigationView {
      List {
        ForEach(self.displayedGoals) { goal in
          NavigationLink(
            destination: GoalGuestView(
              user: self.userViewModel.user,
              goalViewModel: GoalViewModel(goal: goal)
            )
          ) {
            CompletedGoalView(goal: goal)
          }
        }
      }
      .navigationBarTitle("Achievement", displayMode: .inline)
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
        
        trailing: Button(action: self.fetchCompletedGoals) {
          Image(systemName: "arrow.clockwise")
        }
      )
      .onAppear(perform: self.fetchCompletedGoals)
    }
  }
  
  func fetchCompletedGoals() {
    self.goalService.getCompletedByTopicIds(topicIds: self.userViewModel.user.topicIdList) {
      self.displayedGoals = $0
    }
  }
  
}
