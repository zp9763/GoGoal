//
//  ProfileTopicSelection.swift
//  GoGoal
//
//  Created by sj on 11/24/21.
//


import SwiftUI

struct ProfileTopicSelection: View {
  
  var topic: Topic
  var isSelected: Bool
  var action: () -> Void
  
  var body: some View {
    Button(action: self.action) {
      HStack {
        ProfileTopicView(topic: self.topic)
        
        if self.isSelected {
          Image(systemName: "checkmark")
            .foregroundColor(Color.primary)
          Spacer()
        }
      }
    }
  }
  
}
