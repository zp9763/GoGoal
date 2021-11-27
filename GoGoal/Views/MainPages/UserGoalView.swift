//
//  UserGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct UserGoalView: View {
  
  @ObservedObject var userViewModel: UserViewModel
  
  // display in-progress goals by default
  @State var displayInProgress = true
  @State var displayedGoals = [Goal]()
  
  // used to identify subpage navigation and also return to root
  @State var selectedGoalId: String?
  
  var body: some View {
    NavigationView {
      VStack {
        
        Spacer()
        
        HStack {
          
          Spacer()
          
          Button(action: {
            self.displayInProgress = false
            self.updateDisplayedGoals()
          }) {
            if displayInProgress {
              RoundedRectangle(cornerRadius: 40)
                .fill(Color(.systemGray5))
                .frame(width: 100, height: 30, alignment: .center)
                .overlay(
                  Text("✓ Completed")
                    .foregroundColor(.primary)
                    .font(.system(size: 12, weight: .regular))
                )
            } else {
              RoundedRectangle(cornerRadius: 40)
                .fill(Color(.systemGray2))
                .frame(width: 100, height: 30, alignment: .center)
                .overlay(
                  Text("✓ Completed")
                    .foregroundColor(.primary)
                    .font(.system(size: 12, weight: .regular))
                )
            }
          }
          
          Spacer()
          
          Button(action: {
            self.displayInProgress = true
            self.updateDisplayedGoals()
          }) {
            if displayInProgress {
              RoundedRectangle(cornerRadius: 40)
                .fill(Color(.systemGray2))
                .frame(width: 100, height: 30, alignment: .center)
                .overlay(
                  Text("↑ In-Progress")
                    .foregroundColor(.primary)
                    .font(.system(size: 12, weight: .regular))
                )
            } else {
              RoundedRectangle(cornerRadius: 40)
                .fill(Color(.systemGray5))
                .frame(width: 100, height: 30, alignment: .center)
                .overlay(
                  Text("↑ In-Progress")
                    .foregroundColor(.primary)
                    .font(.system(size: 12, weight: .regular))
                )
            }
          }
          
          Spacer()
        }.frame(height: 50)
        
        Spacer()
        
        ScrollView(showsIndicators: false){
          VStack{
            ForEach(self.displayedGoals) { goal in
              NavigationLink(
                destination: GoalProgressView(
                  user: self.userViewModel.user,
                  goalViewModel: GoalViewModel(goal: goal),
                  selectedGoalId: self.$selectedGoalId
                ),
                tag: goal.id!,
                selection: self.$selectedGoalId
              ) {
                UserGoalRowView(goal: goal)
                  .frame(width: 300, height: 110)
                  .clipShape(RoundedRectangle(cornerRadius: 18, style: .circular))
                  .frame(height: 130)
              }
              // fix SwiftUI bug: nested NavigationLink fails on 2nd click
              .isDetailLink(false)
            }
          }
        }
        
        Spacer()
      }
      .navigationBarTitle("Goals", displayMode: .inline)
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
        
        trailing: NavigationLink(
          destination: EditGoalView(
            user: self.userViewModel.user,
            selectedGoalId: self.$selectedGoalId
          )
        ) {
          Image(systemName: "plus")
        }
      )
      .onAppear(perform: {
        self.userViewModel.fetchAllUserGoals() { self.updateDisplayedGoals() }
      })
    }
  }
  
  func updateDisplayedGoals() {
    self.displayedGoals = self.userViewModel.userGoals
      .filter() { $0.isCompleted != self.displayInProgress }
      .sorted() { $0.lastUpdateDate > $1.lastUpdateDate }
  }
  
}
