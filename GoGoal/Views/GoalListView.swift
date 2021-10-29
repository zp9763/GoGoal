//
//  GoalListView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct GoalListView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    List {
      ForEach(viewModel.goalList) { goal in
        Text(goal.title)
      }
    }.onAppear(perform: viewModel.fetchUserGoals)
  }
}

struct GoalListView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    GoalListView(viewModel: ViewModel(user: user))
  }
}
