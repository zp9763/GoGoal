//
//  TopicSelectionView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct TopicSelectionView: View {
  
  var topic: Topic
  var isSelected: Bool
  var action: () -> Void
  
  var body: some View {
    Button(action: self.action) {
      HStack {
        TopicView(topic: self.topic)
        
        if self.isSelected {
          Image(systemName: "checkmark")
          Spacer()
        }
      }
    }
  }
  
}
