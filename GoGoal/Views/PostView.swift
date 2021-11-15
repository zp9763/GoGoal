//
//  PostView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/31/21.
//

import SwiftUI
import FirebaseFirestore

struct PostView: View {
  
  var user: User
  
  @State var post: Post
  
  @State var owner: User?
  
  @State var topicIcon: Image?
  
  @State var postIsLiked = false
  
  let topicService = TopicService()
  let userService = UserService()
  let postService = PostService()
  
  var body: some View {
    VStack {
      Spacer()
      
      if let owner = self.owner {
        HStack {
          
          Image.fromUIImage(uiImage: owner.avatar)?
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 18, height: 18, alignment: .topLeading)
          
          Text(owner.getFullName())
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.leading)
            .font(.system(size: 12))
          
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
            .frame(width: 25, height: 25)
        }
      }

      HStack{
        Text(self.post.content)
          .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
          .foregroundColor(Color.black)
          .font(.system(size: 8))
          .padding(.leading, 18.0)
        
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
      
      HStack {
        Spacer()
        if let _ = self.post.likes?[self.user.id!] {
          Button(action: {
            self.postService.removeUserLike(postId: self.post.id!, userId: self.user.id!)
            self.post.likes!.removeValue(forKey: self.user.id!)
            self.postIsLiked = false
          }) {
            Image(systemName: "hand.thumbsup.fill")
              .resizable()
              .frame(width: 12, height: 12)
          }
        } else {
          Button(action: {
            self.postService.addUserLike(postId: self.post.id!, userId: self.user.id!)
            if self.post.likes == nil {
              self.post.likes = [String: Timestamp]()
            }
            self.post.likes![self.user.id!] = Timestamp.init()
            self.postIsLiked = true
          }) {
            Image(systemName: "hand.thumbsup")
              .resizable()
              .frame(width: 12, height: 12)
          }
        }
        
        Text(String(self.post.likes?.count ?? 0))
          .font(.system(size: 12))
          .padding(.trailing, 8)
      }
      
      Spacer()
    }
    .onAppear(perform: self.fetchPostOwner)
    .onAppear(perform: self.fetchGoalTopicIcon)
  }
  
  func fetchPostOwner() {
    self.userService.getById(id: self.post.userId) {
      self.owner = $0
    }
  }
  
  func fetchGoalTopicIcon() {
    self.topicService.getById(id: self.post.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
}
