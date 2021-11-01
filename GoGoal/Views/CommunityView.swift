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
          PostView(post: $0)
        }
      }
      .navigationBarTitle("Community", displayMode: .inline)
      .navigationBarItems(
        // TODO: community posts filter
        leading: Image(systemName: "equal.circle"),
        
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
    postService.getRecentByTopicIds(topicIds: self.viewModel.user.topicIdList) {
      let displayedCount = min($0.count, CommunityView.MAX_DISPLAY_NUM)
      self.displayedPosts = Array($0[0..<displayedCount])
    }
  }
  
}

struct CommunityView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    CommunityView(viewModel: ViewModel(user: user))
  }
}
