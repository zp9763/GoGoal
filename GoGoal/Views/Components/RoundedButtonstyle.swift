//
//  RoundedButtonStyle.swift
//  GoGoal
//
//  Created by sj on 11/13/21.
//

import SwiftUI

struct RoundedButtonstyle: ButtonStyle {
  
  private let width: CGFloat?
  private let height: CGFloat?
  
  init(width: CGFloat? = 220, height: CGFloat? = 40) {
    self.width = width
    self.height = height
  }
  
  func makeBody(configuration: Configuration) -> some View {
    RoundedButton(configuration: configuration)
      .frame(width: width, height: height, alignment: .center)
  }
  
  struct RoundedButton: View {
    
    let configuration: ButtonStyle.Configuration
    
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    
    var backgroundColor: Color {
      return Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255)
    }
    
    var labelColor: Color {
      return configuration.isPressed ? Color.black : Color.white
    }
    
    var body: some View {
      RoundedRectangle(cornerRadius: 20)
        .overlay(
          RoundedRectangle(cornerRadius: 18)
            .fill(backgroundColor)
            .padding(1)
        )
        .overlay(configuration.label.foregroundColor(labelColor))
        .font(.body)
    }
  }
  
}
