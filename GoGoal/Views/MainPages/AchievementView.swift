//
//  AchievementView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/1/21.
//

import SwiftUI

struct AchievementView: View {
  
  @ObservedObject var userViewModel: UserViewModel
  
  @State var displayedGoals = [Goal]()
  
  let goalService = GoalService()
  
  var body: some View {
    NavigationView {
      ScrollView {
        Spacer().frame(height: 20)
        
        VStack(alignment: .leading) {
          Text("So many people achieved their goals")
            .foregroundColor(.primary)
            .font(.system(size: 15, weight: .bold))
          
          Text("Here are their stories")
            .foregroundColor(.secondary)
            .font(.system(size: 14, weight: .semibold))
        }
        .frame(width: 370, alignment: .leading)
        
        Spacer().frame(height: 20)
        
        VStack(spacing: 20) {
          ForEach(self.displayedGoals) { goal in
            NavigationLink(
              destination: GoalGuestView(
                user: self.userViewModel.user,
                goalViewModel: GoalViewModel(goal: goal)
              )
            ) {
              CompletedGoalView(goal: goal)
                .frame(width: 370)
                .background(Color(#colorLiteral(red: 0.1324110579, green: 0.5444720492, blue: 0.7125854492, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .circular))
            }
          }
        }
        .navigationBarTitle("Achievement", displayMode: .inline)
        .navigationBarItems(
          leading: Menu(content: {
            Button(action: {
              self.displayedGoals = self.displayedGoals
                .sorted() { $0.lastUpdateDate > $1.lastUpdateDate }
            }) {
              Text("Sort by Time")
            }
            
            Button(action: {
              self.displayedGoals = self.displayedGoals
                .sorted() { $0.title < $1.title }
            }) {
              Text("Sort by Title")
            }
            
            Button(action: {
              self.displayedGoals = self.displayedGoals
                .sorted() { $0.duration < $1.duration }
            }) {
              Text("Sort by Duration")
            }
          }) {
            Image(systemName: "equal.circle")
          },
          
          trailing: Button(action: self.fetchCompletedGoals) {
            Image(systemName: "arrow.clockwise")
          }
        )
        .onAppear(perform: self.fetchCompletedGoals)
      }
    }
  }
  
  func fetchCompletedGoals() {
    self.goalService.getCompletedByTopicIds(topicIds: self.userViewModel.user.topicIdList) {
      self.displayedGoals = $0
    }
  }
  
}
