//
//  EditGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct EditGoalView: View {
  
  // scenario 1: navigated from user goal page, need to create a new goal
  @State var user: User?
  @State var title: String = ""
  @State var description: String = ""
  @State var duration: Int = 0
  @State var allTopics = [Topic]()
  @State var selectedTopic : Topic?
  @State var indice: Int = -1
  
  let topicService = TopicService()
  
  // scenario 2: nagivated from goal progress page, need to edit existing goal
  var goal: Goal?
  
  
  let userService = UserService()
  var body: some View {
    NavigationView {
      VStack{
        TextField(
          "Set a goal title",
           text: $title
        )
        Spacer()
        TextField(
          "Describe the goal",
           text: $description
        )
        Spacer()
        HStack{
          Text("Duration: ")
          Text(String(duration))
          Text(" Days")
        }
        Picker(selection: $duration, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/, content: {
          ForEach(5..<61) { number in
            Text("\(number)")
              .tag("\(number)")
          }
        })
        .background(Color.gray.opacity(0.3))
        .pickerStyle(SegmentedPickerStyle())
        Spacer()
//        Picker("Select a tag: ", selection: $topicId){
//          ForEach(allTopics.indices){ indice in
//            HStack{
//              allTopics[indice].icon
//              Text(allTopics[indice].name)
//            }.tag(indice)
//
//
//          }
//        }
        Picker(selection: $indice, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/, content: {
          ForEach(allTopics.indices){ indice in
            allTopics[indice].icon
            
          }
        })
      }
      
      
    }
    .navigationBarTitle("Edit Goal", displayMode: .inline)
    .onAppear(perform: {
      self.fetchAllTopics()
    })
    
    
  }
  
  func fetchUserIfNotPassed() {
    if let userId = self.goal?.userId {
      self.userService.getById(id: userId) {
        self.user = $0!
      }
    }
  }
  
  func fetchAllTopics() {
    self.topicService.getAll(){ topicList in
      self.allTopics = topicList
        .sorted() { $0.name < $1.name }
      
    }
  }
  
}

