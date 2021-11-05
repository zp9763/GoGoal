//
//  AnyGestureRecognizer.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/4/21.
//

import UIKit

class AnyGestureRecognizer: UIGestureRecognizer {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    //To prevent keyboard hide and show when switching from one textfield to another
    if let textField = touches.first?.view, textField is UITextField {
      state = .failed
    } else {
      state = .began
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    state = .ended
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    state = .cancelled
  }
  
}
