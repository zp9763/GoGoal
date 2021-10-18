//
//  User.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
  @DocumentID var id: String?
  var email: String
  var firstName: String
  var lastName: String
  var avatarUrl: String?
  var topicIDs: [String] = []
  var createDate: Timestamp = Timestamp.init()
  var lastUpdateDate: Timestamp = Timestamp.init()
}
