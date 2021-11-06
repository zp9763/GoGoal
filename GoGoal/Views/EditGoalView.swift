//
//  EditGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI
import FirebaseFirestore

struct EditGoalView: View {
  
  private static let DURATION_LOWER_BOUND = 1
  private static let DURATION_UPPER_BOUND = 31
  
  // scenario 1: navigated from user goal page, need to create a new goal
  @State var user: User?
  
  // scenario 2: nagivated from goal progress page, need to edit existing goal
  var goal: Goal?
  
  @State var title: String = ""
  
  @State var description: String = ""
  
  @State var duration: Int = -1
  
  @State var allTopics = [Topic]()
  @State var selectedTopicId: String = ""
  
  @State var fireInputMissingAlert = false
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  let topicService = TopicService()
  let userService = UserService()
  let goalService = GoalService()
  
  var body: some View {
    VStack{
      Spacer()
      
      Group {
        HStack {
          Text("Title:")
            .padding(.leading)
          TextField(self.title, text: $title)
            .padding(.trailing)
        }
        
        Spacer()
        
        HStack {
          Text("Description:")
            .padding(.leading)
          TextField(self.description, text: $description)
            .padding(.trailing)
        }
      }
      
      Spacer()
      
      Group {
        let minDuration = max(self.goal?.checkInDates.count ?? 0, EditGoalView.DURATION_LOWER_BOUND)
        
        Text("Please choose goal duration:")
        
        Picker("Duration", selection: $duration) {
          ForEach(minDuration..<EditGoalView.DURATION_UPPER_BOUND, id: \.self) {
            Text(String($0))
          }
        }
      }
      
      Spacer()
      
      List {
        ForEach(self.allTopics, id: \.self.id!) { topic in
          TopicSelectionView(topic: topic, isSelected: self.selectedTopicId == topic.id!) {
            if self.selectedTopicId == topic.id! {
              self.selectedTopicId = ""
            } else {
              self.selectedTopicId = topic.id!
            }
          }
        }
      }
      
      Spacer()
      
      Button(action: {
        guard self.selectedTopicId != "" && self.title != "" else {
          self.fireInputMissingAlert = true
          return
        }
        
        if var goal = self.goal {
          goal.topicId = self.selectedTopicId
          
          goal.title = self.title
          goal.description = self.description == "" ? nil : self.description
          
          goal.duration = self.duration
          if goal.checkInDates.count == goal.duration {
            goal.isCompleted = true
          }
          
          goal.lastUpdateDate = Timestamp.init()
          self.goalService.createOrUpdate(object: goal)
        } else {
          let goal = Goal(userId: self.user!.id!,
                          topicId: self.selectedTopicId,
                          title: self.title,
                          description: self.description == "" ? nil : self.description,
                          duration: self.duration)
          
          self.goalService.createOrUpdate(object: goal)
        }
        
        self.mode.wrappedValue.dismiss()
      }) {
        Text("Confirm")
      }
      .alert(isPresented: $fireInputMissingAlert) {
        Alert(
          title: Text("Missing Goal Info"),
          message: Text("Goal title empty or topic not selected.")
        )
      }
      
      Spacer()
    }
    .navigationBarTitle("Edit Goal", displayMode: .inline)
    .navigationBarItems(
      trailing: deleteGoalView
    )
    .onAppear(perform: self.fetchUserIfGoalPassed)
    .onAppear(perform: self.fetchAllTopics)
  }
  
  var deleteGoalView: some View {
    if let goal = self.goal {
      return AnyView(
        Button(action: {
          self.goalService.deleteGoalCascade(goal: goal)
        }) {
          Image(systemName: "trash")
        }
      )
    } else {
      // disable delete button when creating a new goal
      return AnyView(EmptyView())
    }
  }
  
  func fetchUserIfGoalPassed() {
    if let goal = self.goal {
      self.userService.getById(id: goal.userId) {
        self.user = $0!
        self.title = goal.title
        self.description = goal.description ?? ""
        self.duration = goal.duration
        self.selectedTopicId = goal.topicId
      }
    }
  }
  
  func fetchAllTopics() {
    self.topicService.getAll() { topicList in
      self.allTopics = topicList
        .sorted() { $0.name < $1.name }
    }
  }
  
}
