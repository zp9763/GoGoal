//
//  EditGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI
import FirebaseFirestore

struct EditGoalView: View {
  
  private static let DURATION_LOWER_BOUND: Int = 1
  private static let DURATION_UPPER_BOUND: Int = 30
  
  // scenario 1: navigated from user goal page, need to create a new goal
  var user: User?
  
  // scenario 2: nagivated from goal progress page, need to edit existing goal
  @ObservedObject var goalViewModel = GoalViewModel()
  
  @State var title: String = ""
  @State var description: String = ""
  @State var duration: Int = (EditGoalView.DURATION_LOWER_BOUND + EditGoalView.DURATION_UPPER_BOUND) / 2
  @State var selectedTopicId: String = ""
  
  @State var fireInputMissingAlert: Bool = false
  @State var inputMissingAlertReason: String = ""
  
  @Binding var selectedGoalId: String?
  
  @State var fireDeleteGoalAlert: Bool = false
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  var body: some View {
    VStack{
      Spacer()
      
      Group {
        HStack {
          Text("Title:")
            .padding(.leading)
          TextField(self.title, text: self.$title)
            .padding(.trailing)
        }
        
        Spacer()
        
        HStack {
          Text("Description:")
            .padding(.leading)
          TextField(self.description, text: self.$description)
            .padding(.trailing)
        }
      }
      
      Spacer()
      
      Group {
        let minDuration = max(self.goalViewModel.goal.checkInDates.count, EditGoalView.DURATION_LOWER_BOUND)
        
        Text("Please choose goal duration:")
        
        Picker("Duration", selection: self.$duration) {
          ForEach(minDuration...EditGoalView.DURATION_UPPER_BOUND, id: \.self) {
            Text(String($0))
          }
        }
      }
      
      Group {
        Spacer()
        
        if self.user == nil {
          // forbidden topic selection for an existing goal
          let topic = self.goalViewModel.allTopics
            .filter() { $0.id! == self.goalViewModel.goal.topicId }
          
          // show TopicView after topic list has been loaded
          if topic.count == 1 {
            TopicView(topic: topic[0])
          } else {
            EmptyView()
          }
        } else {
          // allow topic selection only if creating a new goal
          List {
            ForEach(self.goalViewModel.allTopics, id: \.self.id!) { topic in
              TopicSelectionView(topic: topic, isSelected: self.selectedTopicId == topic.id!) {
                if self.selectedTopicId == topic.id! {
                  self.selectedTopicId = ""
                } else {
                  self.selectedTopicId = topic.id!
                }
              }
            }
          }
        }
        
        Spacer()
      }
      
      Button(action: {
        guard self.title != "" else {
          self.inputMissingAlertReason = "Please enter your goal title."
          self.fireInputMissingAlert = true
          return
        }
        
        guard self.selectedTopicId != "" else {
          self.inputMissingAlertReason = "Please select a topic for your goal."
          self.fireInputMissingAlert = true
          return
        }
        
        if self.user == nil {
          self.goalViewModel.goal.title = self.title
          self.goalViewModel.goal.description = self.description == "" ? nil : self.description
          self.goalViewModel.goal.topicId = self.selectedTopicId
          
          self.goalViewModel.goal.duration = self.duration
          self.goalViewModel.goal.isCompleted =
            self.goalViewModel.goal.checkInDates.count == self.goalViewModel.goal.duration
          
          self.goalViewModel.goal.lastUpdateDate = Timestamp.init()
          self.goalViewModel.goalService.createOrUpdate(object: self.goalViewModel.goal) {
            self.mode.wrappedValue.dismiss()
          }
        } else {
          let goal = Goal(
            userId: self.user!.id!,
            topicId: self.selectedTopicId,
            title: self.title,
            description: self.description == "" ? nil : self.description,
            duration: self.duration
          )
          
          self.goalViewModel.goalService.createOrUpdate(object: goal) {
            self.mode.wrappedValue.dismiss()
          }
        }
      }) {
        Text("Confirm")
      }
      .alert(isPresented: self.$fireInputMissingAlert) {
        Alert(
          title: Text("Missing Goal Info"),
          message: Text(self.inputMissingAlertReason)
        )
      }
      
      Spacer()
    }
    .navigationBarTitle("Edit Goal", displayMode: .inline)
    .navigationBarItems(
      trailing: self.deleteGoalView
    )
    .onAppear(perform: self.preSetGoalInfoIfPassed)
    .onAppear(perform: self.goalViewModel.fetchAllTopics)
  }
  
  var deleteGoalView: some View {
    if self.user == nil {
      // show delete goal button if editing an existing goal
      return AnyView(
        Button(action: {
          self.fireDeleteGoalAlert = true
        }) {
          Image(systemName: "trash")
        }
        .alert(isPresented: self.$fireDeleteGoalAlert) {
          Alert(
            title: Text("Please confirm to delete this goal."),
            message: Text("After deletion, all its historical records cannot be resumed."),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .destructive(Text("Delete")) {
              self.goalViewModel.goalService.deleteGoalCascade(goal: self.goalViewModel.goal) {
                // return to root view: UserGoalView
                self.selectedGoalId = nil
              }
            }
          )
        }
      )
    } else {
      // disable delete goal button if creating a new goal
      return AnyView(EmptyView())
    }
  }
  
  func preSetGoalInfoIfPassed() {
    // fill up goal info fields if editing an existing goal
    if self.user == nil {
      self.title = self.goalViewModel.goal.title
      self.description = self.goalViewModel.goal.description ?? ""
      self.duration = self.goalViewModel.goal.duration
      self.selectedTopicId = self.goalViewModel.goal.topicId
    }
  }
  
}
