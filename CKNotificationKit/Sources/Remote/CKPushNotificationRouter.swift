//
//  CKPushNotificationRouter.swift
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

public class CKPushNotificationRouter {
    
    static let sharedRouter: CKPushNotificationRouter = {
        let instance = CKPushNotificationRouter()
        
        return instance
    }()
    
    public var messageTypeProcessor: ([NSObject: AnyObject] -> String)?
    public var messageTypeKey: String = "messageType"
    
    private var processors: [String: CKPushNotificationProcessor.Type]
    
    private init() {
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
        fetchCompletionHandler:(UIBackgroundFetchResult -> Void)) -> Bool
    {
        
        var isProcessed = false
        
        if let processor = processorWithNotification(notification) {
            processor.process(application, notification: notification, fetchCompletionHandler: fetchCompletionHandler)
            isProcessed = true
        }
        
        return isProcessed
    }
    

    
    public func register(processor processor: CKPushNotificationProcessor.Type) {
        processors[processor.processorType()] = processor
    }
    
    private func processorWithNotification(notification: [NSObject: AnyObject]) -> CKPushNotificationProcessor? {
        
        let messageType: String
        
        if (messageTypeProcessor != nil) {
            messageType = messageTypeProcessor!(notification)
        } else {
            if let type = notification[messageTypeKey] as? String {
                messageType = type
            } else {
                return nil;
            }
        }
        
        if let processor = processors[messageType] {
            return processor.init(notification: notification)
        } else {
            return nil
        }
    }
    
    
    
    
}
