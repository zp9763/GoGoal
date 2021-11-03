//
//  AchievementView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct AchievementView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    NavigationView {
      Text("Hello, World!")
        .navigationBarTitle("Achievement", displayMode: .inline)
        .navigationBarItems(
          leading: Image(systemName: "equal.circle"),
          trailing: Image(systemName: "arrow.clockwise")
        )
    }
  }
  
}

struct AchievementView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    AchievementView(viewModel: ViewModel(user: user))
  }
}
