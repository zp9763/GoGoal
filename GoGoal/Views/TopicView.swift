//
//  TopicView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct TopicView: View {
  
  var topic: Topic
  
  var body: some View {
    HStack {
      Spacer()
      
      topic.icon?
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
      
      Text(topic.name)
      
      Spacer()
    }
  }
  
}
