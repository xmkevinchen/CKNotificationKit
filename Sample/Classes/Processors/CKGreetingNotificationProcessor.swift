//
//  CKGreetingNotificationProcessor.swift
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import CKNotificationKit
import SVProgressHUD
import CocoaLumberjack

class CKGreetingNotificationProcessor: NSObject, CKPushNotificationProcessor {
    
    var notification: [NSObject : AnyObject]
    
    static var processorType: String {
        return "greeting"
    }
    
    required init(notification: [NSObject : AnyObject]) {
        self.notification = notification
    }
    
    func process(application: UIApplication, notification: [NSObject : AnyObject], fetchCompletionHandler: (UIBackgroundFetchResult -> Void)?) {
        switch application.applicationState {
        case .Active:
            if let message = notification["message"] as? String {
                SVProgressHUD.showSuccessWithStatus(message)
            }
            
        case .Background:
            DDLogVerbose("====> Received greeting push notification when application is in background")
            
        case .Inactive:
            DDLogVerbose("====> Received greeting push notification when application is inactive")
        }
        
        fetchCompletionHandler?(.NoData)
    }
}
