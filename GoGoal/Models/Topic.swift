//
//  Topic.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct Topic: Codable, Identifiable {
  
  @DocumentID var id: String? = UUID().uuidString
  
  var name: String
  var iconPath: String
  var icon: Image?
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case iconPath
  }
  
}
