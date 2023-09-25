//
//  LocalNotificationService.swift
//  Navigation
//
//  Created by Ляпин Михаил on 25.09.2023.
//

import Foundation
import UserNotifications


final class LocalNotificationService: NSObject {
    
    private var notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization(){
    
        notificationCenter.requestAuthorization(options: [.provisional, .alert, .badge, .sound], completionHandler: {  success, error in
            
            if let error {
                print("Error occured: ", error)
            }
            
            if success {
                self.registerForLatestUpdaetsIfPossible()
            } else {
                print("Notification authorizaion restricted")
            }
            
        })
        
    }
    
    func registerForLatestUpdaetsIfPossible() {
        
       registerUpdatesCategory()
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "checkUpdatesNotification".localized
        notificationContent.sound = .default
        notificationContent.badge = 1
        notificationContent.categoryIdentifier = "updates"
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 19, minute: 00), repeats: true)
        
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString,
                                                                               content: notificationContent,
                                                                               trigger: notificationTrigger)
        notificationCenter.add(notificationRequest)
        
        
    }
    
    func registerUpdatesCategory() {
        
        let checkForUpdatesAction = UNNotificationAction(identifier: "checkForUpdates", title: "checkForUpdatesUNAction".localized, options: .foreground)
        
        let notificationCategory = UNNotificationCategory(identifier: "updates", actions: [checkForUpdatesAction], intentIdentifiers: [])
        notificationCenter.setNotificationCategories([notificationCategory])
        
    }
    
    
}

