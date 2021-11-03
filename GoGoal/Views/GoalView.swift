//
//  GoalView.swift
//  GoGoal
//
//  Created by sj on 11/3/21.
//

import SwiftUI

struct GoalView: View {
  
  var goal : Goal
  
    var body: some View {
      Text(self.goal.title)
    }
}

