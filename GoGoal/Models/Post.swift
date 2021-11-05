//
//  Post.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Codable, Identifiable {
  
  @DocumentID var id: String? = UUID().uuidString
  
  var userId: String
  var goalId: String
  var topicId: String
  var content: String
  var photosPath: String?
  var createDate: Timestamp = Timestamp.init()
  var likes: [String: Timestamp]?
  var photos: [UIImage]?
  
  enum CodingKeys: CodingKey {
    case id
    case userId
    case goalId
    case topicId
    case content
    case photosPath
    case createDate
  }
  
}
