//
//  GoalGuestView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/15/21.
//

import SwiftUI

struct GoalGuestView: View {
  
  var user: User
  
  @ObservedObject var goalViewModel: GoalViewModel
  
  var body: some View {
    VStack {
      Spacer()
      
      Group {
        HStack {
          Spacer()
          
          self.goalViewModel.topicIcon?
            .resizable()
            .scaledToFit()
            .clipShape(Rectangle())
            .overlay(
              Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .shadow(radius: 40)
            )
            .frame(width: 60, height: 60)
          
          Spacer()
          
          Text(self.goalViewModel.goal.title)
            .bold()
          
          Spacer()
        }
        
        Spacer()
        
        if let description = self.goalViewModel.goal.description {
          Text(description)
          Spacer()
        }
        
        let checkInNum = self.goalViewModel.goal.checkInDates.count
        let progress = Double(checkInNum) / Double(self.goalViewModel.goal.duration)
        
        Text("Progress: \(checkInNum) / \(self.goalViewModel.goal.duration)")
        ProgressView(value: progress)
      }
      
      Spacer()
      
      List {
        ForEach(self.goalViewModel.posts) {
          InnerPostView(user: self.user, post: $0)
        }
      }
      
      Spacer()
    }
    .navigationBarTitle("Progress", displayMode: .inline)
    .onAppear(perform: self.goalViewModel.fetchGoalTopicIcon)
    .onAppear(perform: self.goalViewModel.fetchAllGoalPosts)
  }
  
}
