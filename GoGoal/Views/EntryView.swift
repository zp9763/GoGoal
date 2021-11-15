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
    // if login is marked by auth session, toggle on main view
    if self.authSession.isLoggedin {
      return AnyView(MainView(userModel: self.authSession.userModel))
    }
    
    // try to find returning user from cache when opening app
    else if let authUser = Auth.auth().currentUser {
      self.authSession.login(userEmail: authUser.email!)
    }
    
    // show guest view as long as login has not been marked
    return AnyView(GuestView())
  }
  
}
