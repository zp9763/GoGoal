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
  
  let topicService = TopicService()
  
  var body: some View {
    VStack {
      HStack{
        self.topicIcon?
          .resizable()
          .scaledToFit()
          .frame(width: 25, height: 25)
          .padding(.init(top: 12, leading: 0, bottom: 0, trailing: 250))
      }
      
      Spacer().frame(height: 14)
      
      HStack(alignment: .firstTextBaseline){
        Text(self.goal.title)
          .font(.system(size: 15, weight: .semibold, design: .rounded))
          .foregroundColor(Color(white: 0.2))
          .padding(.init(top: 0, leading: 45, bottom: 0, trailing: 55))
        Spacer()
      }
      
      Spacer()
      
      let checkInNum = self.goal.checkInDates.count
      let progress = Double(checkInNum) / Double(self.goal.duration)
      
      if !self.goal.isCompleted{
        ProgressView(value: progress)
      } 
    }
    .onAppear(perform: self.fetchGoalTopicIcon)
  }
  
  func fetchGoalTopicIcon() {
    self.topicService.getById(id: self.goal.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
}
