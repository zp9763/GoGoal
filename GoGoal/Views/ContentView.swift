//
//  ContentView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import SwiftUI

struct ContentView: View {
  
  var body: some View {
    VStack {
      Spacer()
      Button(action: {
        InitSampleData.createUser()
      }, label: {
        Text("createUser")
      })
      Spacer()
      Button(action: {
        InitSampleData.getAllUser()
      }, label: {
        Text("getAllUser")
      })
      Spacer()
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
