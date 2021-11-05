//
//  AchievementView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct AchievementView: View {

  private static let MAX_DISPLAY_NUM = 5
  
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
        // TODO: achievement goals filter
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
    self.goalService.getCompletedByTopicIds(topicIds: self.viewModel.user.topicIdList) { goalList in
      let displayedCount = min(goalList.count, AchievementView.MAX_DISPLAY_NUM)
      self.displayedGoals = Array(goalList[0..<displayedCount])
        .sorted() { $0.lastUpdateDate > $1.lastUpdateDate }
    }
  }
  
}

struct AchievementView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    AchievementView(viewModel: ViewModel(user: user))
  }
}
