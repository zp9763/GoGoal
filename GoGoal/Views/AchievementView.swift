//
//  AchievementView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct AchievementView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  @State var displayedGoals = [Goal]()
  
  let goalService = GoalService()
  
  var body: some View {
    NavigationView {
      List {
        ForEach(self.displayedGoals) {
          CompletedGoalView(goal: $0)
        }
      }
      .navigationBarTitle("Achievement", displayMode: .inline)
      .navigationBarItems(
        leading: Image(systemName: "equal.circle"),
        trailing: Button(action: {
          self.fetchCompletedGoals()
        }) {
          Image(systemName: "arrow.clockwise")
        }
      )
      .onAppear(perform: self.fetchCompletedGoals)
    }
  }
  
  func fetchCompletedGoals() {
    self.goalService.getCompletedByTopicIds(topicIds: self.viewModel.user.topicIdList) {
      self.displayedGoals = $0
    }
  }
  
}

struct AchievementView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    AchievementView(viewModel: ViewModel(user: user))
  }
}
