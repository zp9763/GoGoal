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
  var content: String?
  var photoUrls: [String]?
  var createDate: Timestamp = Timestamp.init()
  // TODO: try automatic serialization with subcollection
  var likes: [Like]?
}
