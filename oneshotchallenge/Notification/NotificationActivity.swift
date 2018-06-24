//
//  NotificationActivity.swift
//  oneshotchallenge
//
//  Created by Olle Ekberg on 2018-06-18.
//  Copyright © 2018 GalvenD. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationActivityDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}

class NotificationActivity {
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    func createNotification() {
        
        center.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus != .authorized {
                //notifications not allowed
                return
            }
    
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "You have not voted on 10 pictures yet. \nYou need to do this to compete in the challenge"
            content.sound = UNNotificationSound.default()
            
            let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                    title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                                    title: "Delete", options: [.destructive])
            
            let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                                  actions: [snoozeAction,deleteAction],
                                                  intentIdentifiers: [], options: [])
            
            self.center.setNotificationCategories([category])
            content.categoryIdentifier = "UYLReminderCategory"
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
            
            let identifier = "UYLLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            self.center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    // Something went wrong
                    debugPrint(error.localizedDescription)
                    return
                }
                
                debugPrint("Notification created")
            })
            
        })
    }
    
    func deleteNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    func requestNotificationAuth() {
        
        center.requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                //Handle error
                debugPrint(error.localizedDescription)
                return
            }
            self.center.delegate = self as? UNUserNotificationCenterDelegate
        }
    }
}
