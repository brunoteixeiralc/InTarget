//
//  AppDelegate.swift
//  NoAlvo
//
//  Created by Bruno Corrêa on 11/06/21.
//

import UIKit
import Firebase
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        notificationAuthorization()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "InTarget")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    func notificationAuthorization(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert,.sound]) { granted, error in
            if (granted){
                print("We have permission")
            }else {
                print("Permission denied")
            }
        }
        
        ///Test Local Notification. Not showing if the app is foreground
        //testLocalNotification(center: center)
    }

///Function to trigger localNotification
//    func testLocalNotification(center:UNUserNotificationCenter){
//        let content = UNMutableNotificationContent()
//        content.title = "Hello!"
//        content.body = "I am a local notification"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(
//          timeInterval: 10,
//          repeats: false)
//        let request = UNNotificationRequest(
//          identifier: "MyNotification",
//          content: content,
//          trigger: trigger)
//        center.add(request)
//    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Received local notification \(notification)")
    }
    
}

