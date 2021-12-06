//
//  GoalServiceTests.swift
//  GoGoalTests
//
//  Created by Peng Zhao on 12/4/21.
//

import XCTest
@testable import GoGoal

class GoalServiceTests: XCTestCase {
  
  let expired: TimeInterval = 5
  var expectation: XCTestExpectation!
  
  let goalService = GoalService.shared
  let postService = PostService.shared
  
  let goal = Goal(
    userId: UUID().uuidString,
    topicId: "028DA048-5921-4FD4-86A4-10568F088567",
    title: "test title",
    description: "test description",
    duration: 5
  )
  
  override func setUp() {
    self.expectation = expectation(description: "Able to CRUD with Firestore")
    self.goalService.createOrUpdate(object: self.goal)
  }
  
  func testGetByGoalId() {
    self.goalService.getById(id: self.goal.id!) {
      XCTAssertEqual($0?.title, self.goal.title)
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetAllGoals() {
    self.goalService.getAll() { goalList in
      XCTAssertTrue(goalList.map({ $0.id! }).contains(self.goal.id!))
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testGetByUserId() {
    self.goalService.getByUserId(userId: self.goal.userId) { goalList in
      XCTAssertEqual(goalList[0].id!, self.goal.id!)
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
  func testDeleteGoalCascade() {
    let tempGoal = Goal(
      userId: UUID().uuidString,
      topicId: "028DA048-5921-4FD4-86A4-10568F088567",
      title: "temp title",
      description: "temp description",
      duration: 5
    )
    
    self.goalService.createOrUpdate(object: tempGoal) {
      let tempPost = Post(
        userId: tempGoal.userId,
        goalId: tempGoal.id!,
        topicId: tempGoal.topicId,
        content: "test content"
      )
      
      self.postService.createOrUpdate(object: tempPost) {
        self.postService.addPhotos(post: tempPost, images: [UIImage(named: "test_post_photo")!]) {
          self.postService.addUserLike(postId: tempPost.id!, userId: tempGoal.userId) {
            self.goalService.deleteGoalCascade(goal: tempGoal) {
              self.expectation.fulfill()
            }
          }
        }
      }
    }
    
    waitForExpectations(timeout: self.expired * 2)
  }
  
  func testGetCompletedByTopicIds() {
    self.goalService.getCompletedByTopicIds(topicIds: [self.goal.topicId]) { _ in
      self.expectation.fulfill()
    }
    
    waitForExpectations(timeout: self.expired)
  }
  
}
