//
//  FirestoreDecoder.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

class FirestoreDecoder {
  
  static func decode<T: Decodable>(_ document: DocumentSnapshot?) -> T? {
    let result = Result {
      try document?.data(as: T.self)
    }
    
    switch result {
      case .success(let data):
        return data
      case .failure(let err):
        print("Error decoding document: \(err)")
    }
    
    return nil
  }
  
}
