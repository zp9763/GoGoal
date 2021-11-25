//
//  SignUpView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/14/21.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
  
  @EnvironmentObject var authSession: AuthSession
  
  @State var firstName: String = ""
  @State var lastName: String = ""
  
  @State var email: String = ""
  @State var password: String = ""
  
  @State var fireSignUpFailureAlert: Bool = false
  @State var signUpFailureReason: String = ""
  
  @State var allTopics = [Topic]()
  @State var subscribedTopicIds = [String]()
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  let userService = UserService()
  let topicService = TopicService()
  
  var body: some View {
    VStack {
      VStack{
        Text("Go!Goal!")
          .font(.system(size: 30, weight: .bold))
          .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 170))
        
        Spacer().frame(height: 10)
        
        Text("Join the community!")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(Color(.darkGray))
          .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 105))
      }.frame(height: 100)
      
      HStack {
        TextField("First Name", text: self.$firstName)
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
      
      Spacer().frame(height: 40)
      
      HStack {
        TextField("Last Name", text: self.$lastName)
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
      
      Spacer().frame(height: 40)
      
      HStack {
        TextField("Email", text: self.$email)
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
      
      Spacer().frame(height: 40)
      
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
      
      VStack{
        ScrollView(.horizontal) {
          VStack (alignment: .leading){
            Text("Follow topics")
              .font(.system(size: 14, weight: .semibold))
              .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
            Text("Goals with selected topics will show up in community")
              .font(.system(size: 12, weight: .regular))
              .foregroundColor(Color(.darkGray))
              .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
            
            HStack(spacing: 15) {
              Spacer().frame(width: 3)
              ForEach(self.allTopics, id: \.self.id!) { topic in
                TopicSelectionView(topic: topic, isSelected: self.subscribedTopicIds.contains(topic.id!)) {
                  if self.subscribedTopicIds.contains(topic.id!) {
                    self.subscribedTopicIds.removeAll() { $0 == topic.id! }
                  } else {
                    self.subscribedTopicIds.append(topic.id!)
                  }
                }
              }
            }.frame(height: 100)
          }
        }.frame(height: 150)
      }.frame(height: 250)
      
      Button(action: {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { _, err in
          if let err = err {
            self.signUpFailureReason = err.localizedDescription
            self.fireSignUpFailureAlert = true
          } else {
            Auth.auth().signIn(withEmail: self.email, password: self.password) { _, _ in
              if self.firstName == "" && self.lastName == "" {
                self.firstName = "Anonymous"
              }
              
              let newUser = User(
                email: self.email,
                firstName: self.firstName,
                lastName: self.lastName,
                topicIdList: self.subscribedTopicIds
              )
              
              self.userService.createOrUpdate(object: newUser) {
                self.authSession.login(userEmail: self.email) {
                  self.mode.wrappedValue.dismiss()
                }
              }
            }
          }
        }
      }) {
        RoundedRectangle(cornerRadius: 15)
          .fill(Color(.systemBlue))
          .frame(width: 300, height: 50, alignment: .center)
          .overlay(
            Text("Sign Up")
              .foregroundColor(.white)
              .font(.system(size: 16, weight: .semibold))
          )
      }
      .alert(isPresented: self.$fireSignUpFailureAlert) {
        Alert(
          title: Text("Sign Up Error"),
          message: Text(self.signUpFailureReason)
        )
      }
    }
    .onAppear(perform: self.fetchAllTopics)
  }
  
  func fetchAllTopics() {
    self.topicService.getAll() { topicList in
      self.allTopics = topicList
        .sorted() { $0.name < $1.name }
    }
  }
  
}
