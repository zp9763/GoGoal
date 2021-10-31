//
//  UserGoalRowView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct UserGoalRowView: View {
  
  var goal: Goal
    
  @State var topicIcon: Image?
  
  @State var progress: Double = 0
  
  let topicService = TopicService()
  
  var body: some View {
    VStack {
      HStack() {
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
        
        Text(self.goal.title)
        
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
