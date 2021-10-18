//
//  InitSampleData.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

class InitSampleData {
  
  static let userService = UserService()
  
  static var user = User(
    email: "pzhao2@andrew.cmu.edu",
    firstName: "Peng",
    lastName: "Zhao",
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
    user.email = "pzhao2@cmu.edu"
    userService.createOrUpdate(object: user)
  }
  
  static func deleteById() {
    userService.deleteById(id: user.id!)
  }
  
  static func queryUserByLastName() {
    userService.queryByLastName(lastName: "Zhao") { users in
      print(users)
    }
  }

}
