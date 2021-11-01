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
          Label("Goals", systemImage: "bolt.horizontal.circle")
        }
      
      CommunityView(viewModel: self.viewModel)
        .tabItem {
          Label("Community", systemImage: "network")
        }
      
      ProfileView(viewModel: self.viewModel)
        .tabItem {
          Label("Profile", systemImage: "person")
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
