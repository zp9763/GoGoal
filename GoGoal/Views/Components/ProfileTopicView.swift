//
//  ProfileTopicView.swift
//  GoGoal
//
//  Created by sj on 11/24/21.
//

import SwiftUI

struct ProfileTopicView: View {
  
  var topic: Topic
  
  var body: some View {
    HStack {
      Spacer()
      
      self.topic.icon?
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
      
      Text(self.topic.name)
        .foregroundColor(Color.primary)
      
      Spacer()
    }
  }
  
}
