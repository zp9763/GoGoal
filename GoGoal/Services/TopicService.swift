//
//  TopicService.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/18/21.
//

import FirebaseFirestore

class TopicService: BaseRepository<Topic> {
  
  init() {
    let rootRef = Firestore.firestore().collection(.topics)
    super.init(rootRef)
  }
  
  func getByName(name: String, _ completion: @escaping (Topic?) -> Void) {
    let condition = QueryCondition(field: "name", predicate: .equal, value: name)
    queryByFields([condition]) { topicList in
      let topic = topicList.count == 0 ? nil : topicList[0]
      completion(topic)
    }
  }
  
}
