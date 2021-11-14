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
  
  @State private var gradient = LinearGradient(
          gradient: Gradient(colors: [.red, .green, .blue]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
      )
  
  let topicService = TopicService()
  
  var body: some View {
    let gradientStyle = GradientProgressStyle(
                stroke: gradient,
                fill: gradient,
                caption: "Some fancy caption"
            )
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
          .font(.custom("Roboto-Regular",size:20))
        
        Spacer()
      }
      
      let checkInNum = self.goal.checkInDates.count
      let progress = Double(checkInNum) / Double(self.goal.duration)
      
      ProgressView(value: progress)
        .progressViewStyle(gradientStyle) 
      
    }
    .onAppear(perform: self.fetchGoalTopicIcon)
  }
  
  func fetchGoalTopicIcon() {
    self.topicService.getById(id: self.goal.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
}
