//
//  ProfileView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct ProfileView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    List {
      ForEach(viewModel.topicList) { topic in
        HStack {
          Text(topic.name)
          topic.icon!
            .resizable()
            .scaledToFit()
            .clipShape(Rectangle())
            .overlay(
              Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .shadow(radius: 40)
            )
            .frame(width: 100, height: 100)
            .padding()
        }
      }
    }
  }
  
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    ProfileView(viewModel: ViewModel(user: user))
  }
}
