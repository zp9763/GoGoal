//
//  Like.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Like: Codable, Identifiable {
  
  // user id who liked the post
  @DocumentID var id: String?
  
  var createDate: Timestamp = Timestamp.init()
  
}
