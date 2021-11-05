//
//  ImagePicker.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/4/21.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  
  @Binding var isShown: Bool
  @Binding var image: UIImage?
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
  
  func makeCoordinator() -> ImagePickerCordinator {
    return ImagePickerCordinator(isShown: $isShown, image: $image)
  }
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  
}

class ImagePickerCordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  @Binding var isShown: Bool
  @Binding var image: UIImage?
  
  init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
    _isShown = isShown
    _image = image
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    isShown = false
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    isShown = false
  }
  
}
