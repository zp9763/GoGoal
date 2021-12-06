//
//  UserServiceTests.swift
//  GoGoalTests
//
//  Created by Peng Zhao on 11/6/21.
//

import XCTest
@testable import GoGoal

class UserServiceTests: XCTestCase {
  
  let expired: TimeInterval = 5
  var expectation: XCTestExpectation!
  
  let userService = UserService.shared
  
  let user = User(
    email: "testuser@example.com",
    firstName: "Test",
    lastName: "User",
    topicIdList: [
      "025EB914-417C-41A5-8F0B-3EC34F7052F7",
      "028DA048-5921-4FD4-86A4-10568F088567",
      "3EAAA98C-5F33-42B5-99EF-2D881F195DF3",
      "8D4C58F0-A77B-4DE5-B8AE-DED1D37D704B"
    ]
  )
  
  override func setUp() {
    self.expectation = expectation(description: "Able to CRUD with Firestore")
    self.userService.createOrUpdate(object: self.user)
  }
  
  func testGetByUserId() {
    self.userService.getById(id: self.user.id!) {
      XCTAssertEqual($0?.email, self.user.email)
      XCTAssertEqual($0?.getFullName(), "\(self.user.firstName) \(self.user.lastName)")
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetAllUsers() {
    self.userService.getAll() { userList in
      XCTAssertTrue(userList.map({ $0.id! }).contains(self.user.id!))
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testDeleteUser() {
    let tempUser = User(
      email: "tempuser@example.com",
      firstName: "Temp",
      lastName: "User",
      topicIdList: ["025EB914-417C-41A5-8F0B-3EC34F7052F7"]
    )
    
    self.userService.createOrUpdate(object: tempUser) {
      self.userService.deleteById(id: tempUser.id!) {
        self.expectation.fulfill()
      }
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetByEmail() {
    self.userService.getByEmail(email: self.user.email) {
      XCTAssertEqual($0?.email, self.user.email)
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testSetAvatar() {
    self.userService.setAvatar(user: self.user, image: UIImage(named: "default_user_avatar")!) {
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
}
