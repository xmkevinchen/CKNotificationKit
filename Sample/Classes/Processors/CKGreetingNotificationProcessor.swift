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
    
    var notification: [AnyHashable : Any]
    
    static var processorType: String {
        return "greeting"
    }
    
    required init(notification: [AnyHashable : Any]) {
        self.notification = notification
    }
    
    func process(application: UIApplication, notification: [AnyHashable : Any], fetchCompletionHandler: ((UIBackgroundFetchResult) -> Void)?) {
        switch application.applicationState {
        case .active:
            if let message = notification["message"] as? String {
                SVProgressHUD.showSuccess(withStatus: message)
            }
            
        case .background:
            DDLogVerbose("====> Received greeting push notification when application is in background")
            
        case .inactive:
            DDLogVerbose("====> Received greeting push notification when application is inactive")
        }
        
        fetchCompletionHandler?(.newData)
    }
}
