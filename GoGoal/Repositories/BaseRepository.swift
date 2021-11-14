//
//  BaseRepository.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

class BaseRepository<T: Codable & Identifiable> {
  
  let rootRef: CollectionReference
  
  init(_ rootRef: CollectionReference) {
    self.rootRef = rootRef
  }
  
  func getAll(_ completion: @escaping ([T]) -> Void) {
    var objects = [T]()
    
    rootRef.getDocuments() { snapshot, err in
      if let err = err {
        print("Error get documents: \(err)")
      } else {
        for document in snapshot!.documents {
          if let object: T = FirestoreDecoder.decode(document) {
            objects.append(object)
          }
        }
        completion(objects)
      }
    }
  }
  
  func getById(id: String, _ completion: @escaping (T?) -> Void) {
    var object: T?
    
    rootRef.document(id).getDocument() { (document, err) in
      if let err = err {
        print("Error get document: \(err)")
      } else {
        object = FirestoreDecoder.decode(document)
        completion(object)
      }
    }
  }
  
  func createOrUpdate(object: T) {
    do {
      try rootRef.document(object.id as! String).setData(from: object)
    } catch let err {
      print("Error create or update document: \(err)")
    }
  }
  
  func deleteById(id: String) {
    rootRef.document(id).delete() { err in
      if let err = err {
        print("Error delete documents: \(err)")
      }
    }
  }
  
  func queryByFields(queries: [QueryCondition], orders: [OrderCondition]? = nil, limit: Int? = nil,
                     _ completion: @escaping ([T]) -> Void) {
    var queryRef = rootRef as Query
    
    for condition in queries {
      queryRef = queryRef.applyQuery(condition)
    }
    
    if let orders = orders {
      for condition in orders {
        queryRef = queryRef.applyOrder(condition)
      }
    }
    
    if let limit = limit {
      queryRef = queryRef.applyLimit(limit)
    }
    
    var objects = [T]()
    
    queryRef.getDocuments() { snapshot, err in
      if let err = err {
        print("Error get documents: \(err)")
      } else {
        for document in snapshot!.documents {
          if let object: T = FirestoreDecoder.decode(document) {
            objects.append(object)
          }
        }
        completion(objects)
      }
    }
  }
  
}
