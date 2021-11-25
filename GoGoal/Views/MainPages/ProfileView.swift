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
  
  @State var fireChangePwdAlert: Bool = false
  
  @State var showChangePwdWindow = false
  
  @State var oldPassword: String = ""
  @State var newPassword: String = ""
  
  @State var fireBadPwdAlert = false
  
  
  
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
      VStack{
        ZStack{
          //        Rectangle()
          //          .fill(Color(red: 240/255, green: 248/255, blue: 255/255))
          Image("ProfileBackground")
            .resizable()
          //          .scaledToFit()
            .frame(height: 160)
          Button(action: {
            self.showImagePicker = true
          }) {
            Image.fromUIImage(uiImage: self.avatar)?
              .resizable()
              .scaledToFit()
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(Color.white, lineWidth: 7)
                  .shadow(radius: 40)
              )
              .frame(width: 100, height: 100, alignment: .center)
            
              .offset(x: 0, y: 55)
          }
        }
        VStack {
          TextField(self.fullName, text: self.$fullName)
            .font(.title2.bold())
            .fixedSize()
            .onChange(of: self.fullName) {
              let nameSplit = $0.split(separator: " ")
              
              if nameSplit.count > 1 {
                self.userViewModel.user.firstName = String(nameSplit[0])
                self.userViewModel.user.lastName = nameSplit[1..<nameSplit.count].joined(separator: " ")
              } else if nameSplit.count == 1 {
                self.userViewModel.user.firstName = String(nameSplit[0])
                self.userViewModel.user.lastName = ""
              } else {
                self.userViewModel.user.firstName = "Anonymous"
                self.userViewModel.user.lastName = ""
              }
              
              self.userViewModel.user.lastUpdateDate = Timestamp.init()
              self.userViewModel.userService.createOrUpdate(object: self.userViewModel.user)
            }.offset(x: 0, y: 20)
          Text(self.userViewModel.user.email)
            .offset(x: 0, y: 20)
          changePwdView
            .offset(x: 0, y: 20)
          //previous change password view
          //        Group{
          //          VStack{
          
          
          
          //              Text("Password:")
          //                .offset(x: 10, y: 0)
          //              SecureField(self.password, text: self.$password)
          //                .offset(x: 10, y: 0)
          
          
          
          
          //            if self.password != ProfileView.DEFAULT_PASSWORD {
          //              Button(action: {
          //                Auth.auth().currentUser!.updatePassword(to: self.password) { err in
          //                  self.changePwdResponse = err?.localizedDescription ??
          //                  "Password changed successfully! Please login again."
          //                  self.fireChangePwdAlert = true
          //                }
          //              }) {
          //                Text("Change Password")
          //                  .foregroundColor(Color.primary)
          //              }
          //              .alert(isPresented: self.$fireChangePwdAlert) {
          //                Alert(
          //                  title: Text("Change Password"),
          //                  message: Text(self.changePwdResponse),
          //                  dismissButton: .cancel(Text("OK")) {
          //                    if self.changePwdResponse.contains("success") {
          //                      do {
          //                        try Auth.auth().signOut()
          //                        self.authSession.logout()
          //                      } catch let err {
          //                        print("Error sign out: \(err)")
          //                      }
          //                    } else {
          //                      self.password = ProfileView.DEFAULT_PASSWORD
          //                    }
          //                  }
          //                )
          //              }
          //            } else {
          //              Text("Change Password")
          //            }
          
          //          }
          
          //        }                    
          Group {
            Spacer()
            let completedGoalNum = self.userViewModel.userGoals.filter() { $0.isCompleted }.count
            let percent = Double(completedGoalNum) / Double(max(self.userViewModel.userGoals.count, 1))
            Text("Achieved Goals: \(completedGoalNum) / \(self.userViewModel.userGoals.count)")
              .bold()
              .offset(x: 0,y: 20)
            //            ProgressView(value: percent)
            ProgressBar(value:percent)
              .frame(height: 20)
              .foregroundColor(Color(UIColor.systemTeal))
              .padding()
            Spacer()
          }
          Group{
            Text("Subscribed Topics")
              .bold()
            VStack{
              let subscribedTopics = self.userViewModel.allTopics
                .filter() { self.subscribedTopicIds.contains($0.id!) }
                .sorted() { $0.name < $1.name }
              TopicGrid(data:subscribedTopics)
                .padding()
            }
          }
          
          
          Group {
            VStack {
              //previous list
              //
              //            List {
              //              let subscribedTopics = self.userViewModel.allTopics
              //                .filter() { self.subscribedTopicIds.contains($0.id!) }
              //                .sorted() { $0.name < $1.name }
              //
              //              ForEach(subscribedTopics) {
              //                TopicView(topic: $0)
              //              }
              //            }
              Button(action: {
                self.updateSubscribedTopic = true
              }) {
                Text("Update Topic Subscription")
                  .bold()
                  .foregroundColor(Color.white)
                
              }
              .frame(width: 230,height: 15)
              .padding()
              .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255)))
              .clipShape(Capsule())
              .popover(isPresented: self.$updateSubscribedTopic) { topicSubscription }
            }
          }
          Group {
            Button(action: {
              do {
                try Auth.auth().signOut()
                self.authSession.logout()
              } catch let err {
                print("Error sign out: \(err)")
              }
            }) {
              Text("Logout")
                .bold()
                .foregroundColor(Color.white)
            }
            .frame(width: 230,height: 10)
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                          .fill(Color.gray)
                          .opacity(0.5)
            )
            .clipShape(Capsule())
          }
          
          Spacer()
        }
        //      .background(Image("profile_background").resizable())
        //      .navigationBarTitle("Profile", displayMode: .inline)
        .navigationBarHidden(true)
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
  }
  var changePwdView: some View{
    Button(action: {
      self.showChangePwdWindow = true
    }) {
      Text("Change Password")
        .foregroundColor(Color.black)
        .padding()
      
    }
    .frame(width: 180,height: 10)
    .padding()
    .background(Capsule().stroke(lineWidth: 2))
    .clipShape(Capsule())
    .popover(isPresented: $showChangePwdWindow) {
      VStack {
        Spacer()
        
        VStack(alignment: .leading){
          
          Text("Old Password:")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color(.darkGray))
            .padding(.init(top: 0, leading: 55, bottom: 20, trailing: 105))
          
          
          TextField("old password", text: $oldPassword)
            .font(.system(size: 16, weight: .semibold))
            .background(
              RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray5))
                .frame(width: 300, height: 50, alignment: .center)
            )
            .autocapitalization(.none)
            .foregroundColor(.primary)
            .padding(.init(top: 0, leading: 55, bottom: 0, trailing: 55))
          
        }.frame(height: 100)
        
        
        VStack (alignment: .leading){
          Text("New Password:")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color(.darkGray))
            .padding(.init(top: 0, leading: 55, bottom: 20, trailing: 105))
          
          
          TextField("new password", text: $newPassword)
            .font(.system(size: 16, weight: .semibold))
            .background(
              RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray5))
                .frame(width: 300, height: 50, alignment: .center)
            )
            .autocapitalization(.none)
            .foregroundColor(.primary)
            .padding(.init(top: 0, leading: 55, bottom: 0, trailing: 55))
        }.frame(height: 100)
        
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
            .bold()
            .foregroundColor(Color.white)
        }
        .frame(width: 230,height: 15)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255)))
        .clipShape(Capsule())
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
  
  var topicSubscription: some View {
    VStack {
      Spacer()
      List {
        ForEach(self.userViewModel.allTopics, id: \.self.id!) { topic in
          VerticalTopicSelection(topic: topic, isSelected: self.subscribedTopicIds.contains(topic.id!)) {
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
      .buttonStyle(RoundedButtonstyle())
      
      Spacer()
    }
  }
  
}
