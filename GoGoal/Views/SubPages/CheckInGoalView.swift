//
//  CheckInGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI
import FirebaseFirestore

struct CheckInGoalView: View {
  
  private static let PHOTO_COLUMN: Int = 2
  private static let MAX_PHOTO_NUM: Int = 4
  
  @ObservedObject var goalViewModel: GoalViewModel
  
  @State var content: String = ""
  
  @State var showImagePicker: Bool = false
  @State var photos = [UIImage]()
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
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
        
        TextField("mark your progress...", text: self.$content)
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
        self.goalViewModel.goal.checkInDates.append(Timestamp.init())
        
        if self.goalViewModel.goal.checkInDates.count == self.goalViewModel.goal.duration {
          self.goalViewModel.goal.isCompleted = true
        }
        
        self.goalViewModel.goal.lastUpdateDate = Timestamp.init()
        self.goalViewModel.goalService.createOrUpdate(object: self.goalViewModel.goal) {
          // add check-in date only if no content and photos
          guard self.content != "" || self.photos.count > 0 else {
            self.mode.wrappedValue.dismiss()
            return
          }
          
          let post = Post(
            userId: self.goalViewModel.goal.userId,
            goalId: self.goalViewModel.goal.id!,
            topicId: self.goalViewModel.goal.topicId,
            content: self.content == "" ? self.goalViewModel.goal.title : self.content
          )
          
          self.goalViewModel.postService.createOrUpdate(object: post) {
            if self.photos.count > 0 {
              self.goalViewModel.postService.addPhotos(post: post, images: self.photos) {
                self.mode.wrappedValue.dismiss()
              }
            } else {
              self.mode.wrappedValue.dismiss()
            }
          }
        }
      }) {
        Text("Submit")
      }
      
      Spacer()
    }
    .navigationBarTitle("Check In", displayMode: .inline)
    .sheet(isPresented: self.$showImagePicker) {
      PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.photosBinding)
    }
  }
  
}
