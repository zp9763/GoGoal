//
//  TopicService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore
import SwiftUI

class TopicService: BaseRepository<Topic> {
  
  let storage = FileStorage(.topics)
  
  init() {
    let rootRef = Firestore.firestore().collection(.topics)
    super.init(rootRef)
  }
  
  private func loadIcon(_ topic: Topic, _ completion: @escaping (Topic) -> Void) {
    guard let path = topic.iconPath else {
      completion(topic)
      return
    }
    
    storage.downloadFile(fullPath: path) { data in
      var topic = topic
      topic.icon = Image.fromData(data: data)
      completion(topic)
    }
  }
  
  override func getAll(_ completion: @escaping ([Topic]) -> Void) {
    super.getAll() { topicList in
      var topicList = topicList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<topicList.count {
        dispatchGroup.enter()
        self.loadIcon(topicList[i]) { topic in
          topicList[i].icon = topic.icon
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(topicList) }
    }
  }
  
  override func getById(id: String, _ completion: @escaping (Topic?) -> Void) {
    super.getById(id: id) { topic in
      if let topic = topic {
        self.loadIcon(topic) { completion($0) }
      } else {
        completion(nil)
      }
    }
  }
  
  override func queryByFields(_ conditions: [QueryCondition], _ completion: @escaping ([Topic]) -> Void) {
    super.queryByFields(conditions) { topicList in
      var topicList = topicList
      let dispatchGroup = DispatchGroup()
      
      for i in 0..<topicList.count {
        dispatchGroup.enter()
        self.loadIcon(topicList[i]) { topic in
          topicList[i] = topic
          dispatchGroup.leave()
        }
      }
      
      dispatchGroup.notify(queue: .main) { completion(topicList) }
    }
  }
  
  func getByName(name: String, _ completion: @escaping (Topic?) -> Void) {
    let condition = QueryCondition(field: "name", predicate: .equal, value: name)
    queryByFields([condition]) { topicList in
      let topic = topicList.count == 0 ? nil : topicList[0]
      completion(topic)
    }
  }
  
}
