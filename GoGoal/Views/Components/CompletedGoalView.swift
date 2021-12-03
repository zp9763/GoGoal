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
  @State var topicName: String?
  @State var likesCount: Int = 0
  @State var selectedPhotos = [UIImage]()
  
  let topicService = TopicService()
  let postService = PostService()
  let userService = UserService()
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer().frame(height: 18)
      
      HStack(alignment: .top) {
        Spacer().frame(width: 24)
        
        VStack(alignment: .leading) {
          Text(self.goal.title)
            .font(.system(size: 22, weight: .bold))
            .font(.title)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
          
          if let topicName = self.topicName {
            Text("#\(topicName)")
              .font(.system(size: 20, weight: .bold))
              .font(.title)
              .foregroundColor(.white)
          }
          
          if let description = self.goal.description {
            Text(description)
              .lineLimit(3)
              .font(.system(size: 15, weight: .semibold))
              .font(.body)
              .foregroundColor(.white)
              .fixedSize(horizontal: false, vertical: true)
          }
        }
        
        Spacer().frame(width: 18)
      }
      .frame(width: 400, alignment: .leading)
      
      Spacer().frame(height: 10)
      
      HStack(alignment: .top) {
        Spacer().frame(width: 24)
        
        Text("Completed in \(self.goal.duration) day(s)")
          .font(.system(size: 13, weight: .bold))
          .font(.title)
          .foregroundColor(.white)
        
        Spacer()
        
        Text("\(likesCount) like(s)")
          .font(.system(size: 12, weight: .regular))
          .font(.body)
          .foregroundColor(.white)
        
        Spacer().frame(width: 30)
      }
      .frame(width: 400, alignment: .leading)
      
      Spacer()
      
      HStack {
        Spacer().frame(width: 25)
        
        VStack(alignment: .leading) {
          Spacer().frame(height: 7)
          
          HStack {
            if let owner = self.owner {
              Image.fromUIImage(uiImage: owner.avatar)?
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                  Circle()
                    .stroke(Color.white, lineWidth: 0.3)
                )
                .frame(width: 18, height: 18, alignment: .leading)
              
              Text(owner.getFullName())
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
            }
          }
        }
        
        Spacer()
      }
      .frame(width: 400, height: 50, alignment: .top)
      .background(Color(#colorLiteral(red: 0.1376849364, green: 0.4269855777, blue: 0.5450149848, alpha: 1)))
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
      self.topicName = $0?.name
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
