//
//  StorageEnum.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/28/21.
//

import FirebaseStorage

enum StorageEnum: String {
  case users
  case posts
}

extension StorageReference {
  
  func child(_ rootFolder: StorageEnum) -> StorageReference {
    // use dev env by default if no env variable is passed
    let env: String = ProcessInfo.processInfo.environment["ENV"] ?? "dev"
    return self.child("\(rootFolder.rawValue)_\(env)")
  }
  
}

enum ContentType: String {
  case image = "image/png"
}
