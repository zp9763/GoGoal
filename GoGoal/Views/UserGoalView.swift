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
          }
        }
        
        Spacer()
        
        HStack {
          Spacer()
          
          Button(action: {
            self.displayInProgress = false
            updateDisplayGoals()
          }) {
            Text("Completed")
          }
          
          Spacer()
          
          Button(action: {
            self.displayInProgress = true
            updateDisplayGoals()
          }) {
            Text("In-progress")
          }
          
          Spacer()
        }
        
        Spacer()
      }
      .navigationBarTitle("Goals", displayMode: .inline)
      .navigationBarItems(
        // TODO: complete goal list filter
        leading: Image(systemName: "equal.circle"),
        
        trailing: NavigationLink(destination: EditGoalView()) {
          Image(systemName: "plus")
        }
      )
      .onAppear(perform: fetchAllUserGoals)
    }
  }
  
  func fetchAllUserGoals() {
    goalService.getByUserId(userId: viewModel.user.id!) {
      self.viewModel.userGoals = $0
      updateDisplayGoals()
    }
  }
  
  func updateDisplayGoals() {
    self.displayedGoals = viewModel.userGoals
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
