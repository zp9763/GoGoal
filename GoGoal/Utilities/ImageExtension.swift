//
//  ImageExtension.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/30/21.
//

import SwiftUI

extension Image {
  
  static func fromUIImage(uiImage: UIImage?) -> Image? {
    guard let uiImage = uiImage else {
      return nil
    }
    
    return Image(uiImage: uiImage)
  }
  
  static func fromData(data: Data?) -> Image? {
    guard let data = data else {
      return nil
    }
    
    let uiImage = UIImage(data: data)
    return fromUIImage(uiImage: uiImage)
  }
  
}
