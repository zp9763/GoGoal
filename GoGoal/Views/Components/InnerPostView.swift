//
//  InnerPostView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/15/21.
//

import SwiftUI
import FirebaseFirestore

struct InnerPostView: View {
  
  private static let PHOTO_COLUMN: Int = 2
  
  var user: User
  
  @State var post: Post
  
  var postIndex: Int
  
  let postService = PostService()
  
  var body: some View {
    VStack(alignment: .leading) {
      
      Text("Day \(self.postIndex)")
        .font(.system(size: 23))
        .bold()
        .padding()
      
      HStack {
        Image(systemName: "star.fill")
        
        Text(self.post.content)
        
        Spacer()
      }
      
      if let photos = self.post.photos {
        let columns = [GridItem](
          repeating: GridItem(.flexible(minimum: 100, maximum: 120)),
          count: InnerPostView.PHOTO_COLUMN
        )
        
        LazyVGrid(columns: columns) {
          ForEach(photos, id: \.self) {
            Image.fromUIImage(uiImage: $0)?
              .resizable()
              .scaledToFit()
              .clipShape(Rectangle())
              .frame(width: 100, height: 80)
          }
        }
      }
      
      HStack {
        Spacer()
        
        if let _ = self.post.likes?[self.user.id!] {
          Button(action: {
            self.postService.removeUserLike(postId: self.post.id!, userId: self.user.id!) {
              self.post.likes!.removeValue(forKey: self.user.id!)
            }
          }) {
            Image(systemName: "hand.thumbsup.fill")
          }
        } else {
          Button(action: {
            self.postService.addUserLike(postId: self.post.id!, userId: self.user.id!) {
              if self.post.likes == nil {
                self.post.likes = [String: Timestamp]()
              }
              self.post.likes![self.user.id!] = Timestamp.init()
            }
          }) {
            Image(systemName: "hand.thumbsup")
          }
        }
        
        Text(String(self.post.likes?.count ?? 0))
      }
    }
  }
  
}
