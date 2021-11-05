//
//  PostView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/31/21.
//

import SwiftUI

struct PostView: View {
  
  var post: Post
  
  @State var user: User?
  
  @State var topicIcon: Image?
  
  let topicService = TopicService()
  let userService = UserService()
  
  var body: some View {
    VStack {
      Spacer()
      
      if let user = self.user {
        HStack {
          Spacer()
          
          user.avatar?
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(
              Circle()
                .stroke(Color.white, lineWidth: 2)
                .shadow(radius: 40)
            )
            .frame(width: 60, height: 60)
          
          Text(user.getFullName())
            .bold()
          
          Spacer()
        }
      }
      
      HStack {
        Spacer()
        
        self.topicIcon?
          .resizable()
          .scaledToFit()
          .clipShape(Rectangle())
          .overlay(
            Rectangle()
              .stroke(Color.white, lineWidth: 2)
              .shadow(radius: 40)
          )
          .frame(width: 60, height: 60)
        
        Spacer()
        
        Text(self.post.content)
        
        Spacer()
        
        Image(systemName: "heart.fill")
        Text(String(self.post.likes?.count ?? 0))
        
        Spacer()
      }
      
      if let photos = self.post.photos {
        let columns = [GridItem](
          repeating: GridItem(.flexible()),
          count: CheckInGoalView.PHOTO_COLUMN
        )
        
        LazyVGrid(columns: columns) {
          ForEach(photos, id: \.self) {
            Image.fromUIImage(uiImage: $0)?
              .resizable()
              .scaledToFit()
              .clipShape(Rectangle())
              .frame(width: 100, height: 80)
          }
        }
      }
      
      Spacer()
    }
    .onAppear(perform: self.fetchPostUser)
    .onAppear(perform: self.fetchGoalTopicIcon)
  }
  
  func fetchPostUser() {
    self.userService.getById(id: self.post.userId) {
      self.user = $0
    }
  }
  
  func fetchGoalTopicIcon() {
    self.topicService.getById(id: self.post.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
}
