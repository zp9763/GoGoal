//
//  EntryView.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/14/21.
//

import SwiftUI
import FirebaseAuth

struct EntryView: View {
  
  @EnvironmentObject var authSession: AuthSession
  
  var body: some View {
    // if auth session is logged in, toggle on main view
    if self.authSession.isLoggedin {
      return AnyView(MainView(userViewModel: self.authSession.userViewModel))
    }
    
    // find return user from local auth cache when opening app
    else if let authUser = Auth.auth().currentUser {
      self.authSession.login(userEmail: authUser.email!)
    }
    
    // show guest view if auth session is logged out
    return AnyView(GuestView())
  }
  
}
