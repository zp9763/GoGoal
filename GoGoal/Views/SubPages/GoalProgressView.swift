//
//  GoalProgressView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct GoalProgressView: View {
  
  var user: User
  
  @ObservedObject var goalViewModel: GoalViewModel
  
  @State var gotoEditGoal: Bool = false
  
  @Binding var selectedGoalId: String?
  
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
        
        Spacer()
        
        Button(action: {
          self.gotoEditGoal = true
        }) {
          Text("Edit Goal")
        }
        
        NavigationLink(
          destination: EditGoalView(
            goalViewModel: self.goalViewModel,
            selectedGoalId: self.$selectedGoalId
          ),
          isActive: self.$gotoEditGoal
        ) {
          EmptyView()
        }
        // fix SwiftUI bug: nested NavigationLink fails on 2nd click
        .isDetailLink(false)
        .hidden()
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
    .navigationBarItems(
      trailing: self.checkInView
    )
    .onAppear(perform: self.goalViewModel.fetchGoalTopicIcon)
    .onAppear(perform: self.goalViewModel.fetchAllGoalPosts)
  }
  
  var checkInView: some View {
    if self.goalViewModel.goal.isCompleted {
      // disable check-in for completed goals
      return AnyView(EmptyView())
    } else {
      return AnyView(NavigationLink(destination: CheckInGoalView(goalViewModel: self.goalViewModel)) {
        Image(systemName: "square.and.pencil")
      })
    }
  }
  
}
