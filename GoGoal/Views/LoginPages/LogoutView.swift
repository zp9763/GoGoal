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
    ZStack {
      Color.blue.edgesIgnoringSafeArea(.all)
      
      VStack{
        Spacer()
        
        Text("Go!Goal!").font(.largeTitle).bold().foregroundColor(.white)
        
        Spacer()
        
        Image("starting_page_image").frame(width: 100, height: 100, alignment: .center)
        
        Spacer()
        
        Button(action: {
          self.showLoginView = true
        }) {
          Text("Login")
            .bold()
            .foregroundColor(.white)
        }
        .frame(width: 250, height: 15)
        .padding()
        .background(Color.black)
        .clipShape(Capsule())
        
        Button(action: {
          self.showSignUpView = true
        }) {
          Text("Sign Up")
            .bold()
            .foregroundColor(.black)
        }
        .frame(width: 250, height: 15)
        .padding()
        .background(Color.white)
        .clipShape(Capsule())
        
        Spacer()
        
      }
      .alignmentGuide(.bottom, computeValue: { dimension in
        .leastNonzeroMagnitude
      })
    }
    .sheet(isPresented: self.$showLoginView) { LoginView() }
    .sheet(isPresented: self.$showSignUpView) { SignUpView() }
  }
  
}
