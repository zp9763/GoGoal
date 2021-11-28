//
//  GoalProgressView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct GoalProgressView: View {
  
  var user: User
  
  @ObservedObject var goalViewModel: GoalViewModel
  
  @State var gotoEditGoal: Bool = false
  
  @Binding var selectedGoalId: String?
  
  var body: some View {
    VStack {
      
      let checkInNum = self.goalViewModel.goal.checkInDates.count
      //let progress = Double(checkInNum) / Double(self.goalViewModel.goal.duration)
      
      Group {
        VStack {
          Spacer()
            .frame(height: 20)
          HStack{
            Spacer()
            Text(self.goalViewModel.goal.title)
              .font(.system(size: 25))
            self.goalViewModel.topicIcon?
              .resizable()
              .scaledToFit()
              .clipShape(Rectangle())
              .frame(width: 30, height: 30)
            Spacer()
          }.padding([.top, .leading, .trailing])
          
          
          HStack{
            Image(systemName: "star.circle")
              .font(.largeTitle)
            Text("Progress: \(checkInNum) / ")
            Text("\(self.goalViewModel.goal.duration)").bold()
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
        
      }
      
      Button(action: {
        self.gotoEditGoal = true
      }) {
        Text("Edit Goal")
          .foregroundColor(Color.white)
      } .frame(width: 280,height: 10)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 15)
            .fill(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255))
          
        )
        .clipShape(Capsule())
      
      NavigationLink(
        destination: EditGoalView(
          goalViewModel: self.goalViewModel,
          selectedGoalId: self.$selectedGoalId
        ),
        isActive: self.$gotoEditGoal
      ) {
        EmptyView()
      }
      // fix SwiftUI bug: nested NavigationLink fails on 2nd click
      .isDetailLink(false)
      .hidden()
      
      
      if (self.goalViewModel.posts.count >= 1) {
        ZStack{
          Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255)
            .opacity(0.1)
          List {
            Section(header: Text("Posts")
                      .font(.system(size: 25))
                      .foregroundColor(Color.primary)) {
              ForEach(0..<self.goalViewModel.posts.count){ i in
                
                InnerPostView(user: self.user, post: self.goalViewModel.posts[i], postIndex: i)
              }
            }
          }.listStyle(.plain)
        }} else {
          Spacer()
          ZStack{
            Text ("Make your first post today!")
              .font(.system(size: 22))
              .italic()
              .padding()
            
          }
          Spacer()
          
        }
    }
    .navigationBarTitle("", displayMode: .inline)
    .navigationBarItems(
      trailing: self.checkInView
    )
    .onAppear(perform: self.goalViewModel.fetchGoalTopicIcon)
    .onAppear(perform: self.goalViewModel.fetchAllGoalPosts)
  }
  
  var checkInView: some View {
    if self.goalViewModel.goal.isCompleted {
      // disable check-in for completed goals
      return AnyView(EmptyView())
    } else {
      return AnyView(NavigationLink(destination: CheckInGoalView(goalViewModel: self.goalViewModel)) {
        Image(systemName: "square.and.pencil")
      })
    }
  }
  
}
