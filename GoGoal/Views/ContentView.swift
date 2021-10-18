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

      Group {
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
        Button(action: {
          InitSampleData.getById()
        }, label: {
          Text("getById")
        })
      }
      
      Spacer()

      Group{
        Button(action: {
          InitSampleData.updateUser()
        }, label: {
          Text("updateUser")
        })
        Spacer()
        Button(action: {
          InitSampleData.deleteById()
        }, label: {
          Text("deleteById")
        })
        Spacer()
        Button(action: {
          InitSampleData.queryUserByLastName()
        }, label: {
          Text("queryUserByLastName")
        })
      }
      
      Spacer()
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
