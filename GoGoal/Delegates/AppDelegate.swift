//
//  AppDelegate.swift
//  GoGoal
//
//  Created by Peng Zhao on 10/17/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    for fontfamily in UIFont.familyNames{
           for fontname in UIFont.fontNames(forFamilyName: fontfamily){
               print(fontname)
           }
       }
      //customize the font of the navigation bar title
    let attributes = [NSAttributedString.Key.font: UIFont(name: "Pacifico", size: 27)!]
    UINavigationBar.appearance().titleTextAttributes = attributes
    
    // Connect to Cloud Firestore database
    FirebaseApp.configure()
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
 
  
}
