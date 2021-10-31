//
//  UserGoalRowView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct UserGoalRowView: View {
  
  var goal: Goal
  
  @State var optionSelected = false
  @State var optionView: AnyView?
  
  @State var topicIcon: Image?
  
  @State var progress: Double = 0
  
  let topicService = TopicService()
  
  var body: some View {
    VStack {
      HStack() {
        Spacer()
        
        Menu(content: {
          Button(action: {
            self.optionSelected = true
            self.optionView = AnyView(CheckInGoalView(goal: self.goal))
          }) {
            Text("Check-in")
          }
          
          Button(action: {
            self.optionSelected = true
            self.optionView = AnyView(EditGoalView(goal: self.goal))
          }) {
            Text("Edit")
          }
        }) {
          Text("GO")
        }
        .background(
          NavigationLink(destination: self.optionView, isActive: $optionSelected) {
            EmptyView()
          }
        )
        
        Spacer()
        
        Text(self.goal.title)
        
        Spacer()
        
        self.topicIcon?
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
      }
      
      ProgressView(value: progress)
    }
    .onAppear(perform: fetchGoalTopicIcon)
    .onAppear(perform: updateGoalProgressBar)
  }
  
  func fetchGoalTopicIcon() {
    topicService.getById(id: goal.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
  func updateGoalProgressBar() {
    let checkInNum = Double(self.goal.checkInDates?.count ?? 0)
    self.progress = checkInNum / Double(self.goal.duration)
  }
  
}
