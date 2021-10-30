//
//  StorageEnum.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/28/21.
//

import FirebaseStorage

enum StorageEnum: String {
  case topics
  case users
  case posts
}

extension StorageReference {
  func child(_ rootFolder: StorageEnum) -> StorageReference {
    return self.child(rootFolder.rawValue)
  }
}

enum ContentType: String {
  case image = "image/png"
}
