//
//  NotificationManager.swift
//  GoGoal
//
//  Created by Peng Zhao on 12/4/21.
//

import UserNotifications

class NotificationManager {
  
  static let shared = NotificationManager()
  
  var settings: UNNotificationSettings?
  
  func requestAuthorization(_ completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        self.fetchNotificationSettings() {
          completion(granted)
        }
      }
  }
  
  func fetchNotificationSettings(_ completion: @escaping () -> Void) {
    UNUserNotificationCenter.current()
      .getNotificationSettings { settings in
        DispatchQueue.main.async {
          self.settings = settings
          completion()
        }
      }
  }
  
  func scheduleNotification() {
    self.remindCheckInGoals()
    self.notifyNewPosts()
  }
  
  func clearNotification() {
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
  
  func remindCheckInGoals() {
    let content = UNMutableNotificationContent()
    content.threadIdentifier = NotificationType.checkInGoals.rawValue
    content.title = "Check in your goals today"
    content.body = "Mark your efforts on your goals today by checking in!"
    
    let trigger: UNNotificationTrigger =
      UNCalendarNotificationTrigger(
        dateMatching: DateComponents(hour: 9, minute: 00),
        repeats: true
      )
    
    let request = UNNotificationRequest(
      identifier: NotificationType.checkInGoals.rawValue,
      content: content,
      trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request) { err in
      if let err = err {
        print(err)
      }
    }
  }
  
  func notifyNewPosts() {
    let content = UNMutableNotificationContent()
    content.threadIdentifier = NotificationType.newPosts.rawValue
    content.title = "New posts in the community"
    content.body = "See how others make exciting progress towards their goals!"
    
    let trigger: UNNotificationTrigger =
      UNCalendarNotificationTrigger(
        dateMatching: DateComponents(hour: 18, minute: 00),
        repeats: true
      )
    
    let request = UNNotificationRequest(
      identifier: NotificationType.newPosts.rawValue,
      content: content,
      trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request) { err in
      if let err = err {
        print(err)
      }
    }
  }
  
}
