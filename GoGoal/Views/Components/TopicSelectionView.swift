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
      VStack {
        TopicView(topic: self.topic)
        
        Spacer().frame(height: 5)
        
        if self.isSelected {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.primary)
            .font(.system(size: 16, weight: .thin))
          
        } else {
          Image(systemName: "plus")
            .foregroundColor(.primary)
            .font(.system(size: 14, weight: .thin))
        }
        
      }.background(
        RoundedRectangle(cornerRadius: 15)
          .fill(Color(.systemGray5))
          .frame(width: 70, height: 100)
      )
    }
  }
  
}
