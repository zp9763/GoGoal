//
//  CommunityView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct CommunityView: View {
  
  private static let MAX_DISPLAY_NUM = 10
  
  @ObservedObject var viewModel: ViewModel
  
  @State var displayedPosts = [Post]()
  
  let postService = PostService()
  
  var body: some View {
    NavigationView {
      List {
        ForEach(self.displayedPosts) {
          PostView(user: self.viewModel.user, post: $0)
        }
      }
      .navigationBarTitle("Community", displayMode: .inline)
      .navigationBarItems(
        leading: Menu(content: {
          Button(action: {
            self.displayedPosts = self.displayedPosts
              .sorted() { $0.createDate > $1.createDate }
          }) {
            Text("Sort by Time")
          }
          
          Button(action: {
            self.displayedPosts = self.displayedPosts
              .sorted() { $0.topicId < $1.topicId }
          }) {
            Text("Sort by Topic")
          }
          
          Button(action: {
            self.displayedPosts = self.displayedPosts
              .sorted() { $0.likes?.count ?? 0 > $1.likes?.count ?? 0 }
          }) {
            Text("Sort by Likes")
          }
        }) {
          Image(systemName: "equal.circle")
        },
        
        trailing: Button(action: {
          self.fetchRecentPosts()
        }) {
          Image(systemName: "arrow.clockwise")
        }
      )
      .onAppear(perform: self.fetchRecentPosts)
    }
  }
  
  func fetchRecentPosts() {
    self.postService.getRecentByTopicIds(topicIds: self.viewModel.user.topicIdList) { postList in
      let displayedCount = min(postList.count, CommunityView.MAX_DISPLAY_NUM)
      self.displayedPosts = Array(postList[0..<displayedCount])
        .sorted() { $0.createDate > $1.createDate }
    }
  }
  
}

struct CommunityView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    CommunityView(viewModel: ViewModel(user: user))
  }
}
