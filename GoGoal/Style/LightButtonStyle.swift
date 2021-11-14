//
//  LightButtonStyle.swift
//  GoGoal
//
//  Created by sj on 11/13/21.
//

import SwiftUI

struct LightButtonstyle:ButtonStyle{
  private let width:CGFloat?
  private let height:CGFloat?
  
  init(width:CGFloat?=160,height:CGFloat?=40){
    self.width=width
    self.height=height
  }
  func makeBody(configuration:Configuration)->some View{
    LightButton(configuration:configuration)
      .frame(width: width, height: height, alignment: .center)
    }
  struct LightButton:View{
    let configuration:ButtonStyle.Configuration
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    
    var backgroundColor:Color{
      if(configuration.isPressed){
        return Color(red:196/255,green:222/255,blue:246/255)
      }
      return Color(red:196/255,green:222/255,blue:246/255)
    }
    var labelColor:Color{
      if(configuration.isPressed){
        return Color.black
      }
      return Color.black
    }
    
    var body:some View{
      RoundedRectangle(cornerRadius:20)
        .overlay(
        RoundedRectangle(cornerRadius: 18)
          .fill(backgroundColor)
          .padding(1)
        )
        .overlay(configuration.label
                  .foregroundColor(labelColor))
        .font(.body)
      
      
    }
  }
}
