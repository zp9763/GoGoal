//
//  CheckInGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI
import FirebaseFirestore

struct CheckInGoalView: View {
  
  static let PHOTO_COLUMN = 2
  static let MAX_PHOTO_NUM = 4
  
  var goal: Goal
  
  @State var content: String = ""
  
  @State var showImagePicker = false
  @State var photos = [UIImage]()
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  let goalService = GoalService()
  let postService = PostService()
  
  var photosBinding: Binding<UIImage?> {
    Binding<UIImage?>(
      get: { return nil },
      set: {
        if let uiImage = $0 {
          self.photos.append(uiImage)
        }
      }
    )
  }
  
  var body: some View {
    VStack{
      Spacer()
      
      Group {
        Text("What have you done today?")
        
        TextField("mark your progress...", text: $content)
      }
      
      Spacer()
      
      Group {
        let columns = [GridItem](
          repeating: GridItem(.flexible()),
          count: CheckInGoalView.PHOTO_COLUMN
        )
        
        LazyVGrid(columns: columns) {
          ForEach(self.photos, id: \.self) {
            Image.fromUIImage(uiImage: $0)?
              .resizable()
              .scaledToFit()
              .clipShape(Rectangle())
              .frame(width: 100, height: 80)
          }
        }
        
        HStack {
          Spacer()
          
          // deactivate button after reaching photo number limit
          if self.photos.count < CheckInGoalView.MAX_PHOTO_NUM {
            Button(action: {
              self.showImagePicker = true
            }) {
              Text("Add a photo")
            }
          } else {
            Text("Photos are full")
          }
          
          Spacer()
          
          Button(action: {
            _ = self.photos.popLast()
          }) {
            Text("Remove a photo")
          }
          
          Spacer()
        }
      }
      
      Spacer()
      
      Button(action: {
        var goal = self.goal
        goal.checkInDates.append(Timestamp.init())
        
        if goal.checkInDates.count == goal.duration {
          goal.isCompleted = true
        }
        
        goal.lastUpdateDate = Timestamp.init()
        goalService.createOrUpdate(object: goal)
        
        // add check-in date only if no content and photos
        guard self.content != "" || self.photos.count > 0 else {
          self.mode.wrappedValue.dismiss()
          return
        }
        
        let content = self.content == "" ? "Goal: \(self.goal.title)" : self.content
        let post = Post(userId: goal.userId, goalId: goal.id!, topicId: goal.topicId, content: content)
        postService.createOrUpdate(object: post)
        
        if self.photos.count > 0 {
          postService.setPhotos(post: post, images: self.photos)
        }
        
        self.mode.wrappedValue.dismiss()
      }) {
        Text("Submit")
      }
      
      Spacer()
    }
    .navigationBarTitle("Check In", displayMode: .inline)
    .sheet(isPresented: $showImagePicker) {
      PhotoCaptureView(showImagePicker: $showImagePicker, image: photosBinding)
    }
  }
  
}
