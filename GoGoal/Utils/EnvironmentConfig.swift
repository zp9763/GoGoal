//
//  EnvironmentConfig.swift
//  GoGoal
//
//  Created by Peng Zhao on 11/19/21.
//

import Foundation

class EnvironmentConfig {
  
  static func getEnv() -> String {
    // use dev env by default if no env variable is found in plist
    return Bundle.main.object(forInfoDictionaryKey: "Environment") as? String ?? "DEV"
  }
  
}
