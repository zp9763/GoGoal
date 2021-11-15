//
//  MainView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import SwiftUI

struct MainView: View {
  
  @ObservedObject var userViewModel: UserViewModel
  
  var body: some View {
    TabView {
      UserGoalView(userViewModel: self.userViewModel)
        .tabItem {
          Image(systemName: "bolt.horizontal.circle")
        }
      
      CommunityView(userViewModel: self.userViewModel)
        .tabItem {
          Image(systemName: "network")
        }
      
      AchievementView(userViewModel: self.userViewModel)
        .tabItem {
          Image(systemName: "folder.circle")
        }
      
      ProfileView(userViewModel: self.userViewModel)
        .tabItem {
          Image(systemName: "person")
        }
    }
  }
  
}
