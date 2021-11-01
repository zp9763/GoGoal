//
//  GoalProgressView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct GoalProgressView: View {
  
  var goal: Goal
  
  @State var topicIcon: Image?
  
  @State var editSelected: Int? = 0
  
  @State var posts = [Post]()
  
  let topicService = TopicService()
  let postService = PostService()
  
  var body: some View {
    VStack {
      Spacer()
      
      Group {
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
          
          Text(self.goal.title)
            .bold()
          
          Spacer()
        }
        
        Spacer()
        
        if let description = self.goal.description {
          Text(description)
          Spacer()
        }
        
        let checkInNum = self.goal.checkInDates.count
        let progress = Double(checkInNum) / Double(self.goal.duration)
        
        Text("Progress: \(checkInNum) / \(self.goal.duration)")
        ProgressView(value: progress)
        
        Spacer()
        
        NavigationLink(destination: EditGoalView(goal: self.goal), tag: 1, selection: $editSelected) {
          EmptyView()
        }
        .hidden()
        
        Button(action: {
          self.editSelected = 1
        }) {
          Text("Edit Goal")
        }
      }
      
      Spacer()
      
      List {
        ForEach(self.posts) {
          PostView(post: $0)
        }
      }
      
      Spacer()
    }
    .navigationBarTitle("Progress", displayMode: .inline)
    .navigationBarItems(
      trailing: NavigationLink(destination: CheckInGoalView(goal: self.goal)) {
        Image(systemName: "square.and.pencil")
      }
    )
    .onAppear(perform: self.fetchGoalTopicIcon)
    .onAppear(perform: self.fetchGoalPosts)
  }
  
  func fetchGoalTopicIcon() {
    topicService.getById(id: self.goal.topicId) {
      self.topicIcon = $0?.icon
    }
  }
  
  func fetchGoalPosts() {
    postService.getByGoalId(goalId: self.goal.id!) { postList in
      self.posts = postList
        .sorted() { $0.createDate > $1.createDate }
    }
  }
  
}
