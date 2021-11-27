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
      if let owner = self.owner, let goal = self.goal {
        
        HStack {
          Image.fromUIImage(uiImage: owner.avatar)?
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 40, height: 40)
            .padding(.init(top: 10, leading: 10, bottom: 0, trailing: 0))
          VStack(alignment: .leading){
            Text(" \(owner.getFullName())")
              .font(.system(size: 15, weight: .bold))
              .foregroundColor(.primary)
            Text(" • \(goal.title)")
              .font(.system(size: 14, weight: .semibold))
              .foregroundColor(.secondary)
          }
          Spacer()
          self.topicIcon?
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 20))
        }
        
        HStack {
          Spacer().frame(width: 60)
          VStack {
            Text(self.post.content)
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.primary)
          }.frame(width: 300, alignment: .leading)
          Spacer()
        }
        
        if let photos = self.post.photos {
          HStack {
            Spacer()
            
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
            
            Spacer().frame(width: 130)
          }
        }
        
        Spacer().frame(height: 10)
        
        HStack {
          Spacer()
          
          if let _ = self.post.likes?[self.user.id!] {
            Button(action: {
              self.postService.removeUserLike(postId: self.post.id!, userId: self.user.id!) {
                self.post.likes!.removeValue(forKey: self.user.id!)
              }
            }) {
              Image(systemName: "hand.thumbsup.fill")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
            }
          } else {
            Button(action: {
              self.postService.addUserLike(postId: self.post.id!, userId: self.user.id!) {
                if self.post.likes == nil {
                  self.post.likes = [String: Timestamp]()
                }
                self.post.likes![self.user.id!] = Timestamp.init()
              }
            }) {
              Image(systemName: "hand.thumbsup")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
            }
          }
          
          Text(String(self.post.likes?.count ?? 0))
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.secondary)
          
          Spacer().frame(width: 30)
        }
      }
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
