//
//  Topic.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Topic: Codable, Identifiable {
  @DocumentID var id: String? = UUID().uuidString
  var name: String
  var color: String = "black"
}
