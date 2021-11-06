//
//  ProfileView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct ProfileView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  @State var goals = [Goal]()
  
  @State var showChangePwdWindow = false
  
  @State var oldPassword: String = ""
  @State var newPassword: String = ""
  
  @State var fireBadPwdAlert = false
  
  @State var showChangeNameWindow = false
  
  @State var newFirstName: String = ""
  @State var newLastName: String = ""
  
  @State var fireNameEmptyAlert = false
  
  @State var showUpdateSubscribedTopic = false
  @State var allTopics = [Topic]()
  @State var subscribedTopicIds = [String]()
  
  @State var showImagePicker = false
  @State var avatar: UIImage?
  
  let userService = UserService()
  let goalService = GoalService()
  let topicService = TopicService()
  
  var avatarBinding: Binding<UIImage?> {
    Binding<UIImage?>(
      get: { return self.avatar },
      set: {
        if let uiImage = $0 {
          self.avatar = uiImage
          self.userService.setAvatar(user: self.viewModel.user, image: uiImage)
        }
      }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        var user = self.viewModel.user
        
        Spacer()
        
        Group {
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
            
            Text(user.getFullName())
              .bold()
            
            Spacer()
          }
          
          Text(user.email)
        }
        
        Spacer()
        
        Group {
          changePwdView
          
          Spacer()
          
          changeNameView
        }
        
        Spacer()
        
        Group {
          let completedGoalNum = self.goals.filter() { $0.isCompleted }.count
          let percent = Double(completedGoalNum) / Double(self.goals.count)
          
          Text("Achieved Goals: \(completedGoalNum) / \(self.goals.count)")
          ProgressView(value: percent)
        }
        
        Spacer()
        
        Group {
          VStack {
            Text("Subscribed Topics")
            
            List {
              let subscribedTopics = self.allTopics
                .filter() { self.subscribedTopicIds.contains($0.id!) }
              
              ForEach(subscribedTopics) {
                TopicView(topic: $0)
              }
            }
            
            Spacer()
            
            Button(action: {
              self.showUpdateSubscribedTopic = true
            }) {
              Text("Update Topic Subscription")
            }
            .popover(isPresented: $showUpdateSubscribedTopic) {
              VStack {
                Spacer()
                
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
                
                Spacer()
                
                Button(action: {
                  user.topicIdList = Array(self.subscribedTopicIds)
                  userService.createOrUpdate(object: user)
                  self.viewModel.user = user
                  self.showUpdateSubscribedTopic = false
                }) {
                  Text("Confirm")
                }
                
                Spacer()
              }
            }
          }
        }
        
        Spacer()
      }
      .navigationBarTitle("Profile", displayMode: .inline)
      .sheet(isPresented: $showImagePicker) {
        PhotoCaptureView(showImagePicker: $showImagePicker, image: avatarBinding)
      }
      .onAppear(perform: self.completeUserInfo)
      .onAppear(perform: self.fetchAllUserGoals)
      .onAppear(perform: self.fetchAllTopics)
    }
  }
  
  var changePwdView: some View {
    Button(action: {
      self.showChangePwdWindow = true
    }) {
      Text("Change Password")
    }
    .popover(isPresented: $showChangePwdWindow) {
      VStack {
        Spacer()
        
        HStack {
          Text("Old Password:")
            .padding(.leading)
          TextField("old password", text: $oldPassword)
            .padding(.trailing)
        }
        
        Spacer()
        
        HStack {
          Text("New Password:")
            .padding(.leading)
          TextField("new password", text: $newPassword)
            .padding(.trailing)
        }
        
        Spacer()
        
        Button(action: {
          guard self.oldPassword == "123456" else {
            self.fireBadPwdAlert = true
            return
          }
          
          guard self.newPassword.count >= 6 else {
            self.fireBadPwdAlert = true
            return
          }
          
          // TODO: change password
          self.showChangePwdWindow = false
        }) {
          Text("Confirm")
        }
        .alert(isPresented: $fireBadPwdAlert) {
          Alert(
            title: Text("Password Warning"),
            message: Text("Old password incorrect or new password too weak.")
          )
        }
        
        Spacer()
      }
    }
  }
  
  var changeNameView: some View {
    var user = self.viewModel.user
    
    return AnyView(
      Button(action: {
        self.showChangeNameWindow = true
      }) {
        Text("Change User Name")
      }
      .popover(isPresented: $showChangeNameWindow) {
        VStack {
          Spacer()
          
          HStack {
            Text("First Name:")
              .padding(.leading)
            TextField(user.firstName, text: $newFirstName)
              .padding(.trailing)
          }
          
          Spacer()
          
          HStack {
            Text("Last Name:")
              .padding(.leading)
            TextField(user.lastName, text: $newLastName)
              .padding(.trailing)
          }
          
          Spacer()
          
          Button(action: {
            guard self.newFirstName != "" else {
              self.fireNameEmptyAlert = true
              return
            }
            
            user.firstName = self.newFirstName
            user.lastName = self.newLastName
            userService.createOrUpdate(object: user)
            
            self.viewModel.user = user
            self.showChangeNameWindow = false
          }) {
            Text("Confirm")
          }
          .alert(isPresented: $fireNameEmptyAlert) {
            Alert(title: Text("Empty First Name"))
          }
          
          Spacer()
        }
      }
    )
  }
  
  // TODO: temp solution to get full user info
  func completeUserInfo() {
    self.userService.getById(id: self.viewModel.user.id!) {
      self.viewModel.user = $0!
      self.subscribedTopicIds = $0!.topicIdList
      self.avatar = $0!.avatar
    }
  }
  
  func fetchAllUserGoals() {
    self.goalService.getByUserId(userId: self.viewModel.user.id!) {
      self.goals = $0
    }
  }
  
  func fetchAllTopics() {
    self.topicService.getAll() { topicList in
      self.allTopics = topicList
        .sorted() { $0.name < $1.name }
    }
  }
  
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    ProfileView(viewModel: ViewModel(user: user))
  }
}
