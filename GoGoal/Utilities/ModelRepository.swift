//
//  ModelRepository.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import FirebaseFirestore

class ModelRepository<T: Codable & Identifiable> {
  
  let rootRef: CollectionReference
  
  init(_ rootRef: CollectionReference) {
    self.rootRef = rootRef
  }
  
  func getAll() -> [T] {
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
      }
    }
    
    return objects
  }
  
  func getById(_ id: String) -> T? {
    var object: T?
    
    rootRef.document(id).getDocument() { (document, err) in
      if let err = err {
        print("Error get documents: \(err)")
      } else {
        object = FirestoreDecoder.decode(document)
      }
    }
    
    return object
  }
  
  func addOrUpdate(_ object: T) {
    do {
      try rootRef.document(object.id as! String).setData(from: object)
    } catch let err {
      print("Error add or update document: \(err)")
    }
  }
  
  func deleteById(_ id: String) {
    rootRef.document(id).delete() { err in
      if let err = err {
        print("Error delete documents: \(err)")
      }
    }
  }
  
}
