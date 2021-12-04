//
//  SignUpTopicView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct SignUpTopicView: View {
  
  var topic: Topic
  
  var body: some View {
    VStack {
      self.topic.icon?
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
      
      Text(self.topic.name)
        .font(.system(size: 10, weight: .medium))
        .foregroundColor(.primary)
    }
    .frame(width: 70)
  }
  
}
