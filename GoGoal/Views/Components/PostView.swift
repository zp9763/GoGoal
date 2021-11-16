//
//  PostView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/31/21.
//

import SwiftUI
import FirebaseFirestore

struct PostView: View {
  
  private static let PHOTO_COLUMN: Int = 2
  
  var user: User
  
  @State var post: Post
  
  @State var owner: User?
  @State var goal: Goal?
  @State var topicIcon: Image?
  
  let topicService = TopicService()
  let userService = UserService()
  let postService = PostService()
  let goalService = GoalService()
  
  var body: some View {
    VStack {
      Spacer()
      
      if let owner = self.owner, let goal = self.goal {
        HStack {
          Spacer()
          
          Image.fromUIImage(uiImage: owner.avatar)?
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(
              Circle()
                .stroke(Color.white, lineWidth: 2)
                .shadow(radius: 40)
            )
            .frame(width: 60, height: 60)
          
          Text(owner.getFullName())
            .bold()
          
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
          
          Text(goal.title)
          
          Spacer()
        }
      }
      
      HStack {
        Spacer()
        
        Text(self.post.content)
        
        Spacer()
        
        if let _ = self.post.likes?[self.user.id!] {
          Button(action: {
            self.postService.removeUserLike(postId: self.post.id!, userId: self.user.id!)
            self.post.likes!.removeValue(forKey: self.user.id!)
          }) {
            Image(systemName: "hand.thumbsup.fill")
          }
        } else {
          Button(action: {
            self.postService.addUserLike(postId: self.post.id!, userId: self.user.id!)
            if self.post.likes == nil {
              self.post.likes = [String: Timestamp]()
            }
            self.post.likes![self.user.id!] = Timestamp.init()
          }) {
            Image(systemName: "hand.thumbsup")
          }
        }
        
        Text(String(self.post.likes?.count ?? 0))
        
        Spacer()
      }
      
      if let photos = self.post.photos {
        let columns = [GridItem](
          repeating: GridItem(.flexible()),
          count: PostView.PHOTO_COLUMN
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
    .onAppear(perform: self.fetchPostOwner)
    .onAppear(perform: self.fetchPostTopicIcon)
    .onAppear(perform: self.fetchPostGoal)
  }
  
  func fetchPostOwner() {
    self.userService.getById(id: self.post.userId) {
      self.owner = $0
    }
  }
  
  func fetchPostTopicIcon() {
    self.topicService.getById(id: self.post.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
  func fetchPostGoal() {
    self.goalService.getById(id: self.post.goalId) {
      self.goal = $0
    }
  }
  
}
