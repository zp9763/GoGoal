//
//  UserGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct UserGoalView: View {
  
  @ObservedObject var userViewModel: UserViewModel
  
  // display in-progress goals by default
  @State var displayInProgress = true
  @State var displayedGoals = [Goal]()
  
  // used to identify subpage navigation and also return to root
  @State var selectedGoalId: String?
  
  var body: some View {
    NavigationView {
      VStack {
        Spacer()
        
        List {
          ForEach(self.displayedGoals) { goal in
            NavigationLink(
              destination: GoalProgressView(
                user: self.userViewModel.user,
                goalViewModel: GoalViewModel(goal: goal),
                selectedGoalId: self.$selectedGoalId
              ),
              tag: goal.id!,
              selection: self.$selectedGoalId
            ) {
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
        
        trailing: NavigationLink(
          destination: EditGoalView(
            user: self.userViewModel.user,
            selectedGoalId: self.$selectedGoalId
          )
        ) {
          Image(systemName: "plus")
        }
      )
      .onAppear(perform: {
        self.userViewModel.fetchAllUserGoals() { self.updateDisplayedGoals() }
      })
    }
  }
  
  func updateDisplayedGoals() {
    self.displayedGoals = self.userViewModel.userGoals
      .filter() { $0.isCompleted != self.displayInProgress }
      .sorted() { $0.lastUpdateDate > $1.lastUpdateDate }
  }
  
}
