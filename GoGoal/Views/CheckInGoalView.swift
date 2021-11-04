//
//  CheckInGoalView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

struct CheckInGoalView: View {
  
  private static let MAX_PHOTO_NUM = 4
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  var goal: Goal
  
  @State var content: String = ""
  
  @State var showImagePicker = false
  
  @State var uiImage: UIImage? = nil
  
//  @State var photos = [UIImage?]()
//
//  var photosBinding: Binding<UIImage?> {
//    Binding<UIImage?>(
//      get: { return UIImage() },
//      set: { self.photos.append($0) }
//    )
//  }
  
  var body: some View {
    VStack{
      Spacer()
      
      Group {
        Text("What have you done today?")
        
        TextField("mark your progress...", text: $content)
      }
      
      Spacer()
      
      Group {
//        var colums = [GridItem(.flexible()), GridItem(.flexible())]
//
//        LazyVGrid(columns: colums) {
//          ForEach(self.photos, id: \.self) { uiImage in
//            Image.fromUIImage(uiImage: uiImage)?
//              .resizable()
//              .scaledToFit()
//              .clipShape(Rectangle())
//              .overlay(
//                Rectangle()
//                  .stroke(Color.white, lineWidth: 2)
//                  .shadow(radius: 40)
//              )
//              .frame(width: 80, height: 60)
//          }
//        }
        
        Image.fromUIImage(uiImage: uiImage)?
          .resizable()
          .scaledToFit()
//          .clipShape(Rectangle())
//          .overlay(
//            Rectangle()
//              .stroke(Color.white, lineWidth: 2)
//              .shadow(radius: 40)
//          )
//          .frame(width: 80, height: 60)
        
        Button(action: {
          self.showImagePicker = true
        }) {
          Text("add photo")
        }
      }
      
      Spacer()
      
      Button(action: {
        let content = self.content == "" ? "Goal: \(self.goal.title)" : self.content
        
      }) {
        Text("Submit")
      }
      
      Spacer()
    }
    .sheet(isPresented: $showImagePicker) {
      PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$uiImage)
    }
    .navigationBarTitle("Check In", displayMode: .inline)
  }
  
}
