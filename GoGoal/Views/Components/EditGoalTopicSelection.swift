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
        self.topic.icon?
          .resizable()
          .scaledToFit()
          .clipShape(Rectangle())
          .overlay(
            Rectangle()
              .stroke(Color.white, lineWidth: 2)
              .shadow(radius: 40)
          )
          .frame(width: 40, height: 40)
        
        if self.isSelected {
          Rectangle()
            .fill(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255))
            .frame(width: 30, height: 5)
        }
      }.padding()
    }
  }

}
