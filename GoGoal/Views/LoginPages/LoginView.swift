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
      
      HStack{
        Text("Go! Goal!")
          .font(.system(size: 30, weight: .bold))
          .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 170))
      }
      
      Spacer()
        .frame(height: 15)
      
      HStack{
        Text("Achieve everything!")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(Color(.darkGray))
          .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 115))
      }
      
      Spacer()
        .frame(height: 40)
      
      HStack {
        TextField("Email", text: self.$email,
                  onEditingChanged: { _ in self.email = self.email.lowercased() })
          .font(.system(size: 16, weight: .semibold))
          .background(
            RoundedRectangle(cornerRadius: 15)
              .fill(Color(.systemGray5))
              .frame(width: 300, height: 50, alignment: .center)
          )
          .autocapitalization(.none)
          .keyboardType(.emailAddress)
          .foregroundColor(.primary)
          .padding(.init(top: 0, leading: 55, bottom: 0, trailing: 55))
      }
      
      Spacer()
        .frame(height: 50)
      
      HStack {
        SecureField("Password", text: self.$password)
          .font(.system(size: 16, weight: .semibold))
          .background(
            RoundedRectangle(cornerRadius: 15)
              .fill(Color(.systemGray5))
              .frame(width: 300, height: 50, alignment: .center)
          )
          .autocapitalization(.none)
          .foregroundColor(.primary)
          .padding(.init(top: 0, leading: 55, bottom: 0, trailing: 55))
      }
      
      Spacer()
        .frame(height: 38)
      
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
        RoundedRectangle(cornerRadius: 15)
          .fill(Color(.systemBlue))
          .frame(width: 300, height: 50, alignment: .center)
          .overlay(
            Text("Login")
              .foregroundColor(.white)
              .font(.system(size: 16, weight: .semibold))
          )
      }
      .alert(isPresented: self.$fireLoginFailureAlert) {
        Alert(
          title: Text("Login Error"),
          message: Text(self.loginFailureReason)
        )
      }
      
      Spacer()
        .frame(height: 180)
      
    }
  }
  
}
