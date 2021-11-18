//
//  LoginView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/14/21.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
  
  @EnvironmentObject var authSession: AuthSession
  
  @State var email: String = ""
  @State var password: String = ""
  
  @State var fireLoginFailureAlert: Bool = false
  @State var loginFailureReason: String = ""
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Text("Email:")
          .padding(.leading)
        TextField(self.email, text: self.$email)
          .padding(.trailing)
      }
      
      Spacer()
      
      HStack {
        Text("Password:")
          .padding(.leading)
        SecureField(self.password, text: self.$password)
          .padding(.trailing)
      }
      
      Spacer()
      
      Button(action: {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { _, err in
          if let err = err {
            self.loginFailureReason = err.localizedDescription
            self.fireLoginFailureAlert = true
          } else {
            self.authSession.login(userEmail: self.email) {
              self.mode.wrappedValue.dismiss()
            }
          }
        }
      }) {
        Text("Login")
      }
      .alert(isPresented: self.$fireLoginFailureAlert) {
        Alert(
          title: Text("Login Error"),
          message: Text(self.loginFailureReason)
        )
      }
      
      Spacer()
    }
  }
  
}
