//
//  CompletedGoalView.swift
//  GoGoal
//
//  Created by sj on 11/3/21.
//

import SwiftUI

struct CompletedGoalView: View {
  
  private static let PHOTO_COLUMN: Int = 2
  private static let MAX_PHOTO_NUM: Int = 6
  
  var goal: Goal
  
  @State var owner: User?
  @State var topicIcon: Image?
  @State var likesCount: Int = 0
  @State var selectedPhotos = [UIImage]()
  
  let topicService = TopicService()
  let postService = PostService()
  let userService = UserService()
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack() {
        Spacer()
        
        if let owner = self.owner {
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
        }
        
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
        
        Text(self.goal.title)
        
        Spacer()
        
        Image(systemName: "heart.fill")
        
        Text(String(self.likesCount))
        
        Spacer()
      }
      
      let columns = [GridItem](
        repeating: GridItem(.flexible()),
        count: CompletedGoalView.PHOTO_COLUMN
      )
      
      LazyVGrid(columns: columns) {
        ForEach(self.selectedPhotos, id: \.self) {
          Image.fromUIImage(uiImage: $0)?
            .resizable()
            .scaledToFit()
            .clipShape(Rectangle())
            .frame(width: 100, height: 80)
        }
      }
      
      Spacer()
    }
    .onAppear(perform: self.fetchGoalOwner)
    .onAppear(perform: self.fetchGoalTopicIcon)
    .onAppear(perform: self.fetchGoalPosts)
  }
  
  func fetchGoalOwner() {
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
    self.postService.getByGoalId(goalId: self.goal.id!) { postList in
      var likesCount: Int = 0
      var selectedPhotos = [UIImage]()
      
      // sum up likes count and collect selected photos from recent posts
      for post in postList.sorted(by: { $0.createDate > $1.createDate }) {
        likesCount += post.likes?.count ?? 0
        
        if post.photos != nil && selectedPhotos.count < CompletedGoalView.MAX_PHOTO_NUM {
          for photo in post.photos! {
            selectedPhotos.append(photo)
            if selectedPhotos.count == CompletedGoalView.MAX_PHOTO_NUM {
              break
            }
          }
        }
      }
      
      self.likesCount = likesCount
      self.selectedPhotos = selectedPhotos
    }
  }
  
}
