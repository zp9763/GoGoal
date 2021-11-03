//
//  UserGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct UserGoalView: View {
  
  @ObservedObject var viewModel: ViewModel
  
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
            NavigationLink(destination: GoalProgressView(goal: goal)) {
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
        // TODO: user goals filter
        leading: Image(systemName: "equal.circle"),
        
        trailing: NavigationLink(destination: EditGoalView(user: self.viewModel.user)) {
          Image(systemName: "plus")
        }
      )
      .onAppear(perform: self.fetchAllUserGoals)
    }
  }
  
  func fetchAllUserGoals() {
    self.goalService.getByUserId(userId: self.viewModel.user.id!) {
      self.viewModel.userGoals = $0
      self.updateDisplayedGoals()
    }
  }
  
  func updateDisplayedGoals() {
    self.displayedGoals = self.viewModel.userGoals
      .filter() { $0.isCompleted != self.displayInProgress }
      .sorted() { $0.lastUpdateDate > $1.lastUpdateDate }
  }
  
}

struct UserGoalView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    UserGoalView(viewModel: ViewModel(user: user))
  }
}
