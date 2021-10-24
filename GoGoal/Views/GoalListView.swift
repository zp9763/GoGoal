//
//  GoalListView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct GoalListView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  @State var displayedGoals = [Goal]()
  
  var body: some View {
    Text("Hello, World!")
      .onAppear(perform: {
        viewModel.fetchUserGoals()
        displayedGoals = Array(viewModel.goalDict.values)
        print(displayedGoals)
      })
  }
}

struct GoalListView_Previews: PreviewProvider {
  static var previews: some View {
    let user = InitSampleData.user
    GoalListView(viewModel: ViewModel(user: user))
  }
}
