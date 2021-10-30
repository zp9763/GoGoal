//
//  FileStorage.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/29/21.
//

import FirebaseStorage

class FileStorage {
  
  private static let MAX_SIZE: Int64 = 1 * 1024 * 1024
  
  let storage = Storage.storage()
  let rootRef: StorageReference
  
  init() {
    rootRef = storage.reference()
  }
  
  func uploadFile(filePath: String, file: Data, type: ContentType, _ completion: @escaping (String) -> Void) {
    let fileRef = rootRef.child(filePath)
    
    let metadata = StorageMetadata()
    metadata.contentType = type.rawValue
    
    fileRef.putData(file, metadata: metadata) { (metadata, err) in
      guard err == nil else {
        print("Error put metadata: \(String(describing: err))")
        return
      }
      
      fileRef.downloadURL { (url, err) in
        guard let url = url else {
          print("Error get downloadURL: \(String(describing: err))")
          return
        }
        completion(url.absoluteString)
      }
    }
  }
  
  func uploadFolderFiles(folderPath: String, files: [Data], type: ContentType, _ completion: @escaping ([String]) -> Void) {
    var urlList = [String]()
    let dispatchGroup = DispatchGroup()
    
    for i in 0..<files.count {
      dispatchGroup.enter()
      let filePath = "\(folderPath)/file_\(i)"
      self.uploadFile(filePath: filePath, file: files[i], type: type) { url in
        urlList.append(url)
        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) { completion(urlList) }
  }
  
  func downloadFile(url: String, _ completion: @escaping (Data?) -> Void) {
    let urlRef = storage.reference(forURL: url)
    
    urlRef.getData(maxSize: FileStorage.MAX_SIZE) { data, err in
      if let err = err {
        print("Error download data from URL: \(err)")
      } else {
        completion(data)
      }
    }
  }
  
  func deleteFile(url: String) {
    let urlRef = storage.reference(forURL: url)
    
    urlRef.delete() { err in
      if let err = err {
        print("Error delete file: \(err)")
      }
    }
  }
  
}
