//
//  ImageExtension.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

extension Image {
  
  static func fromData(data: Data?) -> Image? {
    guard let data = data else {
      return nil
    }
    
    guard let uiImage = UIImage(data: data) else {
      return nil
    }
    
    return Image(uiImage: uiImage)
  }
  
}
