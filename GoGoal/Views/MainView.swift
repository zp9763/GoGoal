//
//  MainView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import SwiftUI

struct MainView: View {
  
  @ObservedObject var userModel: UserModel
  
  var body: some View {
    TabView {
      UserGoalView(userModel: self.userModel)
        .tabItem {
          Image(systemName: "bolt.horizontal.circle")
        }
      
      CommunityView(userModel: self.userModel)
        .tabItem {
          Image(systemName: "network")
        }
      
      AchievementView(userModel: self.userModel)
        .tabItem {
          Image(systemName: "folder.circle")
        }
      
      ProfileView(userModel: self.userModel)
        .tabItem {
          Image(systemName: "person")
        }
    }
  }
  
}
