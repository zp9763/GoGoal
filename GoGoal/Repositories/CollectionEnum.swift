//
//  CollectionEnum.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

enum CollectionEnum: String {
  case users
  case topics
  case goals
  case posts
  case likes
}

extension Firestore {
  
  func collection(_ collection: CollectionEnum) -> CollectionReference {
    // use dev env by default if no env variable is passed
    let env: String = ProcessInfo.processInfo.environment["ENV"] ?? "dev"
    return self.collection("\(collection.rawValue)_\(env)")
  }
  
}

extension DocumentReference {
  
  func collection(_ collection: CollectionEnum) -> CollectionReference {
    return self.collection(collection.rawValue)
  }
  
}
