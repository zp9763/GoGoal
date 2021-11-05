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
    let uiImage = UIImage.fromData(data: data)
    return fromUIImage(uiImage: uiImage)
  }
  
}

extension UIImage {
  
  static func fromData(data: Data?) -> UIImage? {
    guard let data = data else {
      return nil
    }
    
    return UIImage(data: data)
  }
  
}
