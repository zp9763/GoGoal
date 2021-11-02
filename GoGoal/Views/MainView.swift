//
//  ContentView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import SwiftUI

struct MainView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    TabView {
      UserGoalView(viewModel: self.viewModel)
        .tabItem {
          Image(systemName: "bolt.horizontal.circle")
        }
      
      CommunityView(viewModel: self.viewModel)
        .tabItem {
          Image(systemName: "network")
        }
      
      AchievementView(viewModel: self.viewModel)
        .tabItem {
          Image(systemName: "folder.circle")
        }
      
      ProfileView(viewModel: self.viewModel)
        .tabItem {
          Image(systemName: "person")
        }
    }
    .onAppear(perform: GenSampleData.setUp)
  }
  
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    MainView(viewModel: ViewModel(user: user))
  }
}
