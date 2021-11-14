//
//  RoundedButtonStyle.swift
//  GoGoal
//
//  Created by sj on 11/13/21.
//
import SwiftUI
struct RoundedButtonstyle:ButtonStyle{
  private let width:CGFloat?
  private let height:CGFloat?
  
  init(width:CGFloat?=220,height:CGFloat?=40){
    self.width=width
    self.height=height
  }
  func makeBody(configuration:Configuration)->some View{
    RoundedButton(configuration:configuration)
      .frame(width: width, height: height, alignment: .center)
    }
  struct RoundedButton:View{
    let configuration:ButtonStyle.Configuration
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    
    var backgroundColor:Color{
      if(configuration.isPressed){
//        return Color(red: 95, green: 52, blue: 255)
        return Color.purple
      }
    //return Color(red: 95, green: 52, blue: 255)
     return Color.purple
    }
    var labelColor:Color{
      if(configuration.isPressed){
        return Color.black
      }
      return Color.white
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


