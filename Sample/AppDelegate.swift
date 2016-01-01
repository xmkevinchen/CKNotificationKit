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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        CKPushNotificationRouter.sharedRouter.register(processor: CKGreetingNotificationProcessor.self)
        CKPushNotificationRouter.sharedRouter.register(processor: CKWarningNotificationProcessor.self)
        
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if !CKPushNotificationRouter.sharedRouter.route(application, notification: userInfo, fetchCompletionHandler: nil) {
            DDLogVerbose("====> Received unknown notification \(userInfo)")
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if !CKPushNotificationRouter.sharedRouter.route(application, notification: userInfo, fetchCompletionHandler: completionHandler) {
            DDLogVerbose("====> Received unknown notification \(userInfo)")
        }
    }

}

