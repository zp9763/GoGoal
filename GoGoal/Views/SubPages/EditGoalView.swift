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
    VStack {
      Spacer()
      
      Group {
        HStack {
          Image(systemName: "pencil")
          
          Text("Title:")
            .font(.system(size: 18))
            .foregroundColor(Color(.darkGray))
            .bold()
          
          TextField(self.title, text: self.$title)
            .padding(.trailing)
          
          Spacer()
        }
        .padding()
        
        VStack(alignment: .leading) {
          Text("Description:")
            .font(.system(size: 18))
            .foregroundColor(Color(.darkGray))
            .bold()
            .padding(.leading)
          
          TextField(self.description, text: self.$description)
            .frame(height: 150)
            .background(
              RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black, lineWidth: 3)
            )
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing])
        }
      }
      
      Spacer()

      VStack {
        if self.user == nil {
          // forbidden topic selection for an existing goal
          let topic = self.goalViewModel.allTopics
            .filter() { $0.id! == self.goalViewModel.goal.topicId }
          
          // show TopicView after topic list has been loaded
          if topic.count == 1 {
            HStack {
              Text("The topic you selected:")
                .font(.system(size: 18))
                .foregroundColor(Color(.darkGray))
                .bold()
                .padding(.leading)
              
              Spacer()
            }
            
            HStack {
              topic[0].icon?
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.leading)
                            
              Text(topic[0].name)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .padding(.leading)
              
              Spacer()
            }
          } else {
            EmptyView()
          }
        } else {
          // allow topic selection only if creating a new goal
          VStack {
            HStack {
              Text("Click to choose a topic:")
                .font(.system(size: 18))
                .foregroundColor(Color(.darkGray))
                .bold()
                .padding(.leading)
              
              Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(self.goalViewModel.allTopics, id: \.self.id!) { topic in
                  EditGoalTopicSelection(topic: topic, isSelected: self.selectedTopicId == topic.id!) {
                    if self.selectedTopicId == topic.id! {
                      self.selectedTopicId = ""
                    } else {
                      self.selectedTopicId = topic.id!
                    }
                  }
                }
              }.frame(height: 90)
            }.frame(height: 100)
          }.frame(height: 200)
        }
        
        HStack {
          Text("Click to choose a duration:")
            .font(.system(size: 18))
            .foregroundColor(Color(.darkGray))
            .bold()
            .padding()
          
          ZStack {
            Circle()
              .stroke(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255), lineWidth: 2)
              .frame(width: 40, height: 40)
            
            Picker(
              selection: self.$duration,
              label: Image(systemName: "timer").frame(width: 30, height: 30, alignment: .center)
            ) {
              let minDuration = max(self.goalViewModel.goal.checkInDates.count, EditGoalView.DURATION_LOWER_BOUND)
              
              ForEach((minDuration...EditGoalView.DURATION_UPPER_BOUND).reversed(), id: \.self) {
                Text(String($0))
              }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 20)
            .clipped()
          }
          
          Spacer()
        }
        
        HStack {
          Text("\(self.duration) days")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.primary)
            .padding(.leading)
          
          Spacer()
        }
      }
      
      Spacer()

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
            if self.user!.topicIdList.contains(self.selectedTopicId) {
              self.mode.wrappedValue.dismiss()
            } else {
              // automatically make user to subscribe the new topic if haven't
              var user: User = self.user!
              user.topicIdList.append(self.selectedTopicId)
              user.lastUpdateDate = Timestamp.init()
              self.goalViewModel.userService.createOrUpdate(object: user) {
                self.mode.wrappedValue.dismiss()
              }
            }
          }
        }
      }) {
        Text("Confirm")
          .foregroundColor(Color.white)
      }
      .frame(width: 230, height: 10)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 15)
          .fill(Color(red: 95 / 255, green: 52 / 255, blue: 255 / 255))
      )
      .clipShape(Capsule())
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
