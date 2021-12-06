//
//  TopicServiceTests.swift
//  GoGoalTests
//
//  Created by Peng Zhao on 12/4/21.
//

import XCTest
@testable import GoGoal

class TopicServiceTests: XCTestCase {
  
  let expired: TimeInterval = 5
  var expectation: XCTestExpectation!
  
  let topicService = TopicService.shared
  
  override func setUp() {
    self.expectation = expectation(description: "Able to CRUD with Firestore")
  }
  
  func testGetByTopicId() {
    self.topicService.getById(id: "028DA048-5921-4FD4-86A4-10568F088567") {
      XCTAssertEqual($0?.name, "Sports")
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetAllTopics() {
    self.topicService.getAll() { topicList in
      XCTAssertEqual(topicList.count, 8)
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetByName() {
    self.topicService.getByName(name: "Sports") {
      XCTAssertEqual($0?.id!, "028DA048-5921-4FD4-86A4-10568F088567")
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
}
