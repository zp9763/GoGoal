//
//  TimestampExtension.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/31/21.
//

import FirebaseFirestore

extension Timestamp: Comparable {
  
  public static func < (t1: Timestamp, t2: Timestamp) -> Bool {
    return t1.seconds < t2.seconds
  }
  
  public func printDate() -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd hh:mm"
    return df.string(from: self.dateValue())
  }
  
}
