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
  
  let userService = UserService()
  
  var user = User(
    email: "testuser@example.com",
    firstName: "Test",
    lastName: "User",
    topicIdList: ["028DA048-5921-4FD4-86A4-10568F088567"]
  )
  
  override func setUp() {
    self.expectation = expectation(description: "Able to CRUD with Firestore")
    self.userService.createOrUpdate(object: self.user)
  }
  
  func testGetByUserId() {
    self.userService.getById(id: self.user.id!) {
      XCTAssertEqual($0?.email, self.user.email)
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

}
