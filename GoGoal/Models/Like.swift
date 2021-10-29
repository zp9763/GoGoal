//
//  Like.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Like: Codable, Identifiable {
  @DocumentID var id: String?  // user id who liked the post
  var createDate: Timestamp = Timestamp.init()
}
