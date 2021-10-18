//
//  InitSampleData.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

class InitSampleData {
  
  static let userService = UserService()
  
  static func createUser() {
    userService.createOrUpdate(object: User(
      email: "zp9763@gmail.com",
      firstName: "Peng",
      lastName: "Zhao",
      avatarUrl: nil
    ))
  }
  
  static func getAllUser() {
    let users = userService.getAll()
    print(users)
  }
  
}
