//
//  GoalGuestView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/15/21.
//

import SwiftUI

struct GoalGuestView: View {
  
  var user: User
  
  @State var owner: User?
  
  @ObservedObject var goalViewModel: GoalViewModel
  
  let userService = UserService.shared
  
  var body: some View {
    VStack {
      Spacer()
      
      Group {
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
              .frame(width: 40, height: 40)
            
            Text(owner.getFullName())
              .bold()
            
            Spacer()
          }
        }
      }
      
      VStack {
        HStack {
          Spacer()
          
          Text(self.goalViewModel.goal.title)
            .font(.system(size: 25))
          
          self.goalViewModel.topicIcon?
            .resizable()
            .scaledToFit()
            .clipShape(Rectangle())
            .frame(width: 30, height: 30)
          
          Spacer()
        }
        .padding([.top, .leading, .trailing])
        
        HStack {
          Image(systemName: "star.circle")
            .font(.largeTitle)
          
          let checkInNum = self.goalViewModel.goal.checkInDates.count
          Text("Progress: \(checkInNum) /")
            .font(.system(size: 20))
          
          Text("\(self.goalViewModel.goal.duration)")
            .font(.system(size: 20))
        }
        
        if let description = self.goalViewModel.goal.description {
          Text(description)
            .lineLimit(7)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(Color(.darkGray))
            .padding()
        }
      }
      
      List {
        ForEach(self.goalViewModel.posts) {
          InnerPostView(user: self.user, post: $0)
        }
      }
      
      Spacer()
    }
    .onAppear(perform: self.fetchGoalOwner)
    .onAppear(perform: self.goalViewModel.fetchGoalTopicIcon)
    .onAppear(perform: self.goalViewModel.fetchAllGoalPosts)
  }
  
  func fetchGoalOwner() {
    self.userService.getById(id: self.goalViewModel.goal.userId) {
      self.owner = $0
    }
  }
  
}
