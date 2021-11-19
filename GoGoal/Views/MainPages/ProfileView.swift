//
//  ProfileView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
  
  private static let DEFAULT_PASSWORD: String = "******"
  
  @EnvironmentObject var authSession: AuthSession
  
  @ObservedObject var userViewModel: UserViewModel
  
  @State var fullName: String = ""
  
  @State var showImagePicker: Bool = false
  @State var avatar: UIImage?
  
  @State var password: String = ProfileView.DEFAULT_PASSWORD
  @State var fireChangePwdAlert: Bool = false
  @State var changePwdResponse: String = ""
  
  @State var updateSubscribedTopic: Bool = false
  @State var subscribedTopicIds = [String]()
  
  var avatarBinding: Binding<UIImage?> {
    Binding<UIImage?>(
      get: { return self.avatar },
      set: {
        if let uiImage = $0 {
          self.userViewModel.userService.setAvatar(user: self.userViewModel.user, image: uiImage) {
            self.avatar = uiImage
          }
        }
      }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Group {
          Spacer()
          
          HStack {
            Spacer()
            
            Button(action: {
              self.showImagePicker = true
            }) {
              Image.fromUIImage(uiImage: self.avatar)?
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                  Circle()
                    .stroke(Color.white, lineWidth: 2)
                    .shadow(radius: 40)
                )
                .frame(width: 60, height: 60)
            }
            
            Spacer()
            
            TextField(self.fullName, text: self.$fullName)
              .onChange(of: self.fullName) {
                let nameSplit = $0.split(separator: " ")
                
                if nameSplit.count > 1 {
                  self.userViewModel.user.lastName = nameSplit[1..<nameSplit.count].joined(separator: " ")
                } else if nameSplit.count == 1 {
                  self.userViewModel.user.firstName = String(nameSplit[0])
                } else {
                  self.userViewModel.user.firstName = "Anonymous"
                }
                
                self.userViewModel.user.lastUpdateDate = Timestamp.init()
                self.userViewModel.userService.createOrUpdate(object: self.userViewModel.user)
              }
            
            Spacer()
          }
          
          Text(self.userViewModel.user.email)
          
          Spacer()
        }
        
        Group {
          HStack {
            Text("Password:")
              .padding(.leading)
            SecureField(self.password, text: self.$password)
              .padding(.trailing)
          }
          
          if self.password != ProfileView.DEFAULT_PASSWORD {
            Button(action: {
              Auth.auth().currentUser!.updatePassword(to: self.password) { err in
                if let err = err {
                  self.changePwdResponse = err.localizedDescription
                } else {
                  do {
                    try Auth.auth().signOut()
                    self.authSession.logout()
                    self.changePwdResponse =
                      "Password changed successfully! Please login again."
                  } catch let err {
                    print("Error sign out: \(err)")
                  }
                }
                
                self.fireChangePwdAlert = true
              }
            }) {
              Text("Change Password")
            }
            .alert(isPresented: self.$fireChangePwdAlert) {
              Alert(
                title: Text("Change Password"),
                message: Text(self.changePwdResponse)
              )
            }
          } else {
            Text("Change Password")
          }
        }
        
        Group {
          Spacer()
          
          let completedGoalNum = self.userViewModel.userGoals.filter() { $0.isCompleted }.count
          let percent = Double(completedGoalNum) / Double(max(self.userViewModel.userGoals.count, 1))
          
          Text("Achieved Goals: \(completedGoalNum) / \(self.userViewModel.userGoals.count)")
          ProgressView(value: percent)
          
          Spacer()
        }
        
        Group {
          VStack {
            Text("Subscribed Topics")
            
            List {
              let subscribedTopics = self.userViewModel.allTopics
                .filter() { self.subscribedTopicIds.contains($0.id!) }
                .sorted() { $0.name < $1.name }
              
              ForEach(subscribedTopics) {
                TopicView(topic: $0)
              }
            }
            
            Spacer()
            
            Button(action: {
              self.updateSubscribedTopic = true
            }) {
              Text("Update Topic Subscription")
            }
            .popover(isPresented: self.$updateSubscribedTopic) { topicSubscription }
          }
        }
        
        Group {
          Spacer()
          
          Button(action: {
            do {
              try Auth.auth().signOut()
              self.authSession.logout()
            } catch let err {
              print("Error sign out: \(err)")
            }
          }) {
            Text("Logout")
          }
          
          Spacer()
        }
      }
      .navigationBarTitle("Profile", displayMode: .inline)
      .sheet(isPresented: self.$showImagePicker) {
        PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.avatarBinding)
      }
      .onAppear(perform: { self.userViewModel.fetchAllUserGoals() } )
      .onAppear(perform: self.userViewModel.fetchAllTopics)
      .onAppear(perform: {
        self.fullName = self.userViewModel.user.getFullName()
        self.avatar = self.userViewModel.user.avatar
        self.subscribedTopicIds = self.userViewModel.user.topicIdList
      })
    }
  }
  
  var topicSubscription: some View {
    VStack {
      Spacer()
      
      List {
        ForEach(self.userViewModel.allTopics, id: \.self.id!) { topic in
          TopicSelectionView(topic: topic, isSelected: self.subscribedTopicIds.contains(topic.id!)) {
            if self.subscribedTopicIds.contains(topic.id!) {
              self.subscribedTopicIds.removeAll() { $0 == topic.id! }
            } else {
              self.subscribedTopicIds.append(topic.id!)
            }
          }
        }
      }
      
      Spacer()
      
      Button(action: {
        self.userViewModel.user.topicIdList = self.subscribedTopicIds
        self.userViewModel.user.lastUpdateDate = Timestamp.init()
        self.userViewModel.userService.createOrUpdate(object: self.userViewModel.user) {
          self.updateSubscribedTopic = false
        }
      }) {
        Text("Confirm")
      }
      
      Spacer()
    }
  }
  
}
