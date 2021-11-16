//
//  LogoutView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/14/21.
//

import SwiftUI

struct LogoutView: View {
  
  @State var showLoginView: Bool = false
  @State var showSignUpView: Bool = false
  
  var body: some View {
    VStack {
      Spacer()
      
      Button(action: {
        self.showLoginView = true
      }) {
        Text("Login")
      }
      
      Spacer()
      
      Button(action: {
        self.showSignUpView = true
      }) {
        Text("Sign Up")
      }
      
      Spacer()
    }
    .sheet(isPresented: self.$showLoginView) { LoginView() }
    .sheet(isPresented: self.$showSignUpView) { SignUpView() }
  }
  
}
