//
//  ProgressBar.swift
//  GoGoal
//
//  Created by sj on 11/24/21.
//

import SwiftUI

struct ProgressBar: View {
  var value:Double
  
  var body: some View {
    ZStack(alignment: .leading){
      RoundedRectangle(cornerRadius: 20).fill(Color(red: 240 / 255, green: 248 / 255, blue: 255 / 255))
        .frame(width: 270, height: 15)
      
      RoundedRectangle(cornerRadius: 20).fill(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255))
        .frame(width: 270 * value, height: 15)
    }
  }
  
}
