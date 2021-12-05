//
//  PostServiceTests.swift
//  GoGoalTests
//
//  Created by Peng Zhao on 12/4/21.
//

import XCTest
@testable import GoGoal

class PostServiceTests: XCTestCase {
  
  let expired: TimeInterval = 5
  var expectation: XCTestExpectation!
  
  let postService = PostService()
  
  let post = Post(
    userId: UUID().uuidString,
    goalId: UUID().uuidString,
    topicId: "028DA048-5921-4FD4-86A4-10568F088567",
    content: "test content"
  )
  
  override func setUp() {
    self.expectation = expectation(description: "Able to CRUD with Firestore")
    self.postService.createOrUpdate(object: self.post)
  }
  
  func testAddPhotos() {
    self.postService.addPhotos(post: self.post, images: [UIImage(named: "test_post_photo")!]) {
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testAddUserLike() {
    self.postService.addUserLike(postId: self.post.id!, userId: self.post.userId) {
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testRemoveUserLike() {
    self.postService.removeUserLike(postId: self.post.id!, userId: self.post.userId) {
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetById() {
    self.postService.getById(id: self.post.id!) {
      XCTAssertEqual($0?.content, self.post.content)
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetAllPosts() {
    self.postService.getAll() { postList in
      XCTAssertTrue(postList.map({ $0.id! }).contains(self.post.id!))
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetByGoalId() {
    self.postService.getByGoalId(goalId: self.post.goalId) { postList in
      XCTAssertEqual(postList[0].id!, self.post.id!)
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetRecentByTopicIds() {
    self.postService.getRecentByTopicIds(topicIds: [self.post.topicId]) { _ in
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
}
