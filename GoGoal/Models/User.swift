//
//  User.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct User: Codable, Identifiable {
  
  @DocumentID var id: String? = UUID().uuidString
  
  var email: String
  var firstName: String
  var lastName: String
  var avatarUrl: String?
  var topicIdList: [String]?
  var createDate: Timestamp = Timestamp.init()
  var lastUpdateDate: Timestamp = Timestamp.init()
  var avatar: Image?
  
  enum CodingKeys: CodingKey {
    case id
    case email
    case firstName
    case lastName
    case avatarUrl
    case topicIdList
    case createDate
    case lastUpdateDate
  }
  
}
