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
      Color.blue.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
      
      // TODO: disable environment tag when releasing app
//      Group {
//        Text("Environment: \(EnvironmentConfig.getEnv())")
//        Text("(toggled on for app developers)")
//        Spacer()
//      }
      
      VStack{
        Spacer()
        Text("Go!Goal!").font(.largeTitle).bold().foregroundColor(.white)
        Spacer()
        Image("starting_page_image").frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
      
        
      }.alignmentGuide(.bottom, computeValue: { dimension in
        .leastNonzeroMagnitude
      })

      

    }
    //.background(Color(.purple).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    .sheet(isPresented: self.$showLoginView) { LoginView() }
    .sheet(isPresented: self.$showSignUpView) { SignUpView() }
  }
  
}
