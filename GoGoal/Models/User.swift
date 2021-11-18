//
//  User.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
  
  @DocumentID var id: String? = UUID().uuidString
  
  var email: String
  var firstName: String
  var lastName: String
  var avatarPath: String?
  var topicIdList: [String] = []
  var createDate: Timestamp = Timestamp.init()
  var lastUpdateDate: Timestamp = Timestamp.init()
  var avatar: UIImage?
  
  enum CodingKeys: CodingKey {
    case id
    case email
    case firstName
    case lastName
    case avatarPath
    case topicIdList
    case createDate
    case lastUpdateDate
  }
  
  func getFullName() -> String {
    if self.firstName != "" && self.lastName != "" {
      return "\(self.firstName) \(self.lastName)"
    } else if self.lastName != "" {
      return self.lastName
    } else {
      return self.firstName
    }
  }
  
}
