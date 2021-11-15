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
      
      if let owner = self.owner {
        HStack {
          
          Image.fromUIImage(uiImage: owner.avatar)?
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(
              Circle()
                .stroke(Color.white, lineWidth: 2)
                .shadow(radius: 40)
            )
            .frame(width: 18, height: 18, alignment: .topLeading)
            
          
          Text(owner.getFullName())
            .font(.system(size: 10))
          
          Spacer()
          
          Image(systemName: "heart.fill")
          
          Text(String(self.likesCount))
          
        }
      }
      
      Spacer()
      
      HStack() {
        
        VStack{
        Text(self.goal.title)
          .bold()
          .font(.system(size: 20))
        
        if let description = self.goal.description {
          Text(description)
            .font(.system(size: 18))
          
        }
        }
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
          .frame(width: 15, height: 15)

      }
      
//      let columns = [GridItem](
//        repeating: GridItem(.flexible()),
//        count: CompletedGoalView.PHOTO_COLUMN
//      )
      
//      LazyVGrid(columns: columns) {
//        ForEach(self.samplePhotos, id: \.self) {
//          Image.fromUIImage(uiImage: $0)?
//            .resizable()
//            .scaledToFit()
//            .clipShape(Rectangle())
//            .frame(width: 100, height: 80)
//        }
//      }
      
    }
    .background(Color .white)
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .circular))
    .frame(width: 350, height: 250)
    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    .padding()
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
