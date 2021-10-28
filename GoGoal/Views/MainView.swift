//
//  ContentView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import SwiftUI

struct MainView: View {
  
  @ObservedObject var viewModel = ViewModel(user: GenSampleData.user)
  
  var body: some View {
    TabView {
      GoalListView(viewModel: viewModel)
        .tabItem {
          Label("Goals", systemImage: "list.dash")
        }
      
      CommunityView()
        .tabItem {
          Label("Community", systemImage: "list.dash")
        }
      
      ProfileView(viewModel: viewModel)
        .tabItem {
          Label("Profile", systemImage: "list.dash")
        }
    }
    .onAppear(perform: GenSampleData.setUp)
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
