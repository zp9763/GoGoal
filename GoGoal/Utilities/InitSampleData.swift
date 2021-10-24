//
//  InitSampleData.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

class InitSampleData {
  
  static let userService = UserService()
  
  static var user = User(
    email: "sihanc@andrew.cmu.edu",
    firstName: "Sihan",
    lastName: "Chen",
    avatarUrl: nil
  )
  
  static func createUser() {
    userService.createOrUpdate(object: user)
  }
  
  static func getAllUser() {
    userService.getAll() { users in
      print(users)
    }
  }
  
  static func getById() {
    userService.getById(id: user.id!) { user in
      print(user ?? "not found!")
    }
  }
  
  static func updateUser() {
    user.email = "sihanc@cmu.edu"
    userService.createOrUpdate(object: user)
  }
  
  static func deleteById() {
    userService.deleteById(id: user.id!)
  }
  
  static func queryUserByName() {
    userService.queryByName(
      firstName: "Sihan", lastName: "Chen"
    ) { users in
      print(users)
    }
  }
  
}
