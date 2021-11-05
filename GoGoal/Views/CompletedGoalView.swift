//
//  CompletedGoalView.swift
//  GoGoal
//
//  Created by sj on 11/3/21.
//

import SwiftUI

struct CompletedGoalView: View {
  
  private static let PHOTO_COLUMN = 2
  private static let MAX_PHOTO_NUM = 4
    
  var goal: Goal

  @State var owner: User?

  @State var topicIcon: Image?

  @State var likesCount = 0
  
  @State var samplePhotos = [UIImage]()

  let topicService = TopicService()
  let postService = PostService()
  let userService = UserService()
  
  var body: some View {
    VStack {
      Spacer()
      
      if let owner = self.owner {
        HStack {
          Spacer()
          
          owner.avatar?
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
          
          Image(systemName: "heart.fill")
          
          Text(String(self.likesCount))
          
          Spacer()
        }
      }
      
      HStack() {
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
        
        Text(self.goal.title)
        
        Spacer()
      }
      
      let columns = [GridItem](
        repeating: GridItem(.flexible()),
        count: CompletedGoalView.PHOTO_COLUMN
      )
      
      LazyVGrid(columns: columns) {
        ForEach(self.samplePhotos, id: \.self) {
          Image.fromUIImage(uiImage: $0)?
            .resizable()
            .scaledToFit()
            .clipShape(Rectangle())
            .frame(width: 100, height: 80)
        }
      }
      
      Spacer()
    }
    .onAppear(perform: self.fetchPostOwner)
    .onAppear(perform: self.fetchGoalTopicIcon)
    .onAppear(perform: self.fetchGoalPosts)
  }
  
  func fetchPostOwner() {
    self.userService.getById(id: self.goal.userId) {
      self.owner = $0
    }
  }
  
  func fetchGoalTopicIcon() {
    self.topicService.getById(id: self.goal.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
  func fetchGoalPosts() {
    postService.getByGoalId(goalId: self.goal.id!) { postList in
      var likes = 0
      var samplePhotos = [UIImage]()
      
      for post in postList.sorted(by: { $0.createDate > $1.createDate }) {
        likes += post.likes?.count ?? 0
        
        if post.photos != nil && samplePhotos.count < CompletedGoalView.MAX_PHOTO_NUM {
          for photo in post.photos! {
            samplePhotos.append(photo)
            if samplePhotos.count == CompletedGoalView.MAX_PHOTO_NUM {
              break
            }
          }
        }
      }
      
      self.likesCount = likes
      self.samplePhotos = samplePhotos
    }
  }
  
}
