//
//  AppDelegate.swift
//  Sample
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit
import CKNotificationKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        CKPushNotificationRouter.sharedRouter.register(processor: CKGreetingNotificationProcessor.self)
        CKPushNotificationRouter.sharedRouter.register(processor: CKWarningNotificationProcessor.self)
        
        let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
        application.registerUserNotificationSettings(settings)
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if !CKPushNotificationRouter.sharedRouter.route(application: application, notification: userInfo, fetchCompletionHandler: completionHandler) {
            DDLogVerbose("====> Received unknown notification \(userInfo)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if !CKPushNotificationRouter.sharedRouter.route(application: application, notification: userInfo, fetchCompletionHandler: nil) {
            DDLogVerbose("====> Received unknown notification \(userInfo)")
        }
    }
    

}

