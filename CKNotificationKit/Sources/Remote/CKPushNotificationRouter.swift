//
//  CKPushNotificationRouter.swift
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit
import CocoaLumberjack

@objc public class CKPushNotificationRouter: NSObject {
    
    public static let sharedRouter: CKPushNotificationRouter = {
        let instance = CKPushNotificationRouter()
        
        return instance
    }()
    
    public var messageTypeProcessor: ([NSObject: AnyObject] -> String)?
    public var messageTypeKey: String = "messageType"
    
    var processors: [String: CKPushNotificationProcessor.Type]
    
    private override init() {
        self.processors = [String: CKPushNotificationProcessor.Type]()
    }
    
    /**
     The routing method which should be called in UIApplicationDelegate method passed the parameters directly

     ```
     public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
     
        CKPushNotificationRouter.sharedRouter
            .route(application, notification: notification, fetchCompletionHandler: fetchCompletionHandler)
     }
     ```
     
     - parameter application:
     - parameter notification:
     - parameter fetchCompletionHandler:
     
     - returns: 
        * true    - when the notification could be processed
        * false   - when the notification can't be processed, which means there's not processor for it
     */
    public func route(application: UIApplication,
        notification:[NSObject: AnyObject],
        fetchCompletionHandler:(UIBackgroundFetchResult -> Void)?) -> Bool
    {
        
        DDLogVerbose("====> Application.state = \(application.applicationState)")
        DDLogVerbose("====> Received notification = \(notification)")
        
        var isProcessed = false
        
        if let processor = processorWithNotification(notification) {
            processor.process(application, notification: notification, fetchCompletionHandler: fetchCompletionHandler)
            isProcessed = true
        }
        
        return isProcessed
    }
    

    
    public func register(processor processor: CKPushNotificationProcessor.Type) {
        processors[processor.processorType] = processor
    }
    
    public func unregister(processor processor: CKPushNotificationProcessor.Type) {
        processors.removeValueForKey(processor.processorType)
    }
    
    private func processorWithNotification(notification: [NSObject: AnyObject]) -> CKPushNotificationProcessor? {
        
        let messageType: String
        
        if (messageTypeProcessor != nil) {
            messageType = messageTypeProcessor!(notification)
        } else {
            if let type = notification[messageTypeKey] as? String {
                messageType = type
            } else {                
                DDLogVerbose("====> No registered processor for notification = \(notification)")
                return nil;
            }
        }
        
        if let processor = processors[messageType] {
            DDLogVerbose("====> Found registered processor for notification = \(notification)")
            return processor.init(notification: notification)
        } else {
            DDLogVerbose("====> No registered processor for notification = \(notification)")
            return nil
        }
    }
    
    
    
    
}
