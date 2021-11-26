//
//  StepperView.swift
//  GoGoal
//
//  Created by sj on 11/25/21.
//

import SwiftUI

struct StepperView: View {
  @State private var counter : Int = 0
    var body: some View {
      VStack {
        Stepper(onIncrement: {
          self.counter += 1
        }, onDecrement: {self.counter -= 1}){
          Text.init("\(counter)")
            .padding(10)
        }
        .padding(100)
      }
    }
}

struct StepperView_Previews: PreviewProvider {
    static var previews: some View {
        StepperView()
    }
}
