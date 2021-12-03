//
//  EditGoalTopicSelection.swift
//  GoGoal
//
//  Created by sj on 11/28/21.
//

import SwiftUI

struct EditGoalTopicSelection: View {
  
  var topic: Topic
  var isSelected: Bool
  var action: () -> Void
  
  var body: some View {
    Button(action: self.action) {
      VStack {
        VStack{
        self.topic.icon?
            .resizable()
            .clipShape(Circle())
            .shadow(radius: 5)
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
            .frame(width: 40, height: 40)
          
          Text(topic.name)
            .foregroundColor(Color.primary)
            .font(.system(size: 15))
            
        }
        
        if self.isSelected {
          Rectangle()
            .fill(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255))
            .frame(width: 30, height: 5)
        }
      }.padding()
    }
  }

}
