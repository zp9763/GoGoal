//
//  Like.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Like: Codable, Identifiable {
  @DocumentID var id: String? = UUID().uuidString
  var userId: String
  var isActive: Bool
  var lastUpdateDate: Timestamp = Timestamp.init()
}
