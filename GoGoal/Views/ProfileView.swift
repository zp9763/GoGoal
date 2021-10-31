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
    Text("Hello, World!")
  }
  
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    let user = GenSampleData.user
    ProfileView(viewModel: ViewModel(user: user))
  }
}
