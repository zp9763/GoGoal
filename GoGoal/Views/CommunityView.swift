//
//  CommunityView.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/24/21.
//

import SwiftUI

struct CommunityView: View {
  
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    Text("Hello, World!")
  }
  
}

struct CommunityView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    CommunityView(viewModel: ViewModel(user: user))
  }
}
