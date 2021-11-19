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
    return self.collection("\(collection.rawValue)_\(EnvironmentConfig.getEnv().lowercased())")
  }
  
}

extension DocumentReference {
  
  func collection(_ collection: CollectionEnum) -> CollectionReference {
    return self.collection(collection.rawValue)
  }
  
}
