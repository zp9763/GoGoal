//
//  Goal.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Goal: Codable, Identifiable {
  
  @DocumentID var id: String? = UUID().uuidString
  
  var userId: String
  var topicId: String
  var title: String
  var description: String?
  var duration: Int
  var checkInDates: [Timestamp]?
  var isCompleted: Bool = false
  var createDate: Timestamp = Timestamp.init()
  var lastUpdateDate: Timestamp = Timestamp.init()
  
}
