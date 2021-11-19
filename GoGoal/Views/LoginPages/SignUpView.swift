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
      Spacer()
      
      Group {
        HStack {
          Text("First Name:")
            .padding(.leading)
          TextField(self.firstName, text: self.$firstName)
            .padding(.trailing)
        }
        
        Spacer()
        
        HStack {
          Text("Last Name:")
            .padding(.leading)
          TextField(self.lastName, text: self.$lastName)
            .padding(.trailing)
        }
      }
      
      Spacer()
      
      Group {
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
      }
      
      Spacer()
      
      Group {
        Text("Select topics you want to follow:")
        
        List {
          ForEach(self.allTopics, id: \.self.id!) { topic in
            TopicSelectionView(topic: topic, isSelected: self.subscribedTopicIds.contains(topic.id!)) {
              if self.subscribedTopicIds.contains(topic.id!) {
                self.subscribedTopicIds.removeAll() { $0 == topic.id! }
              } else {
                self.subscribedTopicIds.append(topic.id!)
              }
            }
          }
        }
      }
      
      Spacer()
      
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
        Text("Sign Up")
      }
      .alert(isPresented: self.$fireSignUpFailureAlert) {
        Alert(
          title: Text("Sign Up Error"),
          message: Text(self.signUpFailureReason)
        )
      }
      
      Spacer()
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