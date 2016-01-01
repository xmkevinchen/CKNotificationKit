//
//  CKPushNotificationRouterSpec.swift
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import Quick
import Nimble


@testable import CKNotificationKit

class CKPushNotificationRouterSpec: QuickSpec {
    
    override func spec() {
        
        describe("CKPushNotificationRouter") {
            
            let application = UIApplication.sharedApplication()
            
            beforeEach {
                CKPushNotificationRouter.sharedRouter.register(processor: CKGreetingProcessor.self)
                CKPushNotificationRouter.sharedRouter.register(processor: CKWarningProcessor.self)
                CKPushNotificationRouter.sharedRouter.register(processor: CKInfoProcessor.self)
                CKPushNotificationRouter.sharedRouter.messageTypeProcessor = nil
            }
            
            afterEach {
                CKPushNotificationRouter.sharedRouter.unregister(processor: CKGreetingProcessor.self)
                CKPushNotificationRouter.sharedRouter.unregister(processor: CKWarningProcessor.self)
                CKPushNotificationRouter.sharedRouter.unregister(processor: CKInfoProcessor.self)
            }
            
            context("when using default message type key") {
                                
                context("when received greeting push notification") {
                    
                    let notification = [
                        "messageType" : "greeting",
                        "message" : "Hello"
                    ]
                    
                    it("router should route correctly") {
                        expect(CKPushNotificationRouter.sharedRouter.route(application, notification: notification, fetchCompletionHandler: nil)).to(beTruthy())
                        
                        CKPushNotificationRouter.sharedRouter.unregister(processor: CKGreetingProcessor.self)
                        expect(CKPushNotificationRouter.sharedRouter.route(application, notification: notification, fetchCompletionHandler: nil)).to(beFalsy())
                        
                    }
                }
                
            }
            
            context("when using default message type processor") {
                
                beforeEach {
                    CKPushNotificationRouter.sharedRouter.messageTypeProcessor = { _ in
                        return "warning"
                    }
                }
                
                context("when received warning push notification") {
                    
                    let notification = [
                        "messageType" : "warning",
                        "message" : "Hello"
                    ]
                    
                    it("router should route correctly") {
                        expect(CKPushNotificationRouter.sharedRouter.route(application, notification: notification, fetchCompletionHandler: nil)).to(beTruthy())
                        
                        CKPushNotificationRouter.sharedRouter.unregister(processor: CKWarningProcessor.self)
                        expect(CKPushNotificationRouter.sharedRouter.route(application, notification: notification, fetchCompletionHandler: nil)).to(beFalsy())
                        
                    }
                }
            }
            
            context("when received unknown push notification type") {
                
                let notification = [
                    "messageType" : "debugging",
                    "message" : "Hello"
                ]
                
                it("router should route correctly") {
                    expect(CKPushNotificationRouter.sharedRouter.route(application, notification: notification, fetchCompletionHandler: nil)).to(beFalsy())
                    
                }
            }

            context("when received unknown push notification type") {
                
                let notification = [
                    "messageType" : "greeting",
                    "message" : "Hello"
                ]
                
                beforeEach {
                    CKPushNotificationRouter.sharedRouter.messageTypeKey = "type"
                }
                
                
                it("router should route correctly") {
                    expect(CKPushNotificationRouter.sharedRouter.route(application, notification: notification, fetchCompletionHandler: nil)).to(beFalsy())
                    
                }
            }
            
        }
    }
    
    class CKGreetingProcessor: NSObject, CKPushNotificationProcessor {
        
        var notification: [NSObject: AnyObject]
        
        static func processorType() -> String {
            return "greeting"
        }
        
        required init(notification: [NSObject : AnyObject]) {
            self.notification = notification
        }
        
        func process(application: UIApplication, notification: [NSObject : AnyObject], fetchCompletionHandler: (UIBackgroundFetchResult -> Void)?) {}
        
    }
    
    class CKWarningProcessor: NSObject, CKPushNotificationProcessor {
        
        var notification: [NSObject: AnyObject]
        
        static func processorType() -> String {
            return "warning"
        }
        
        required init(notification: [NSObject : AnyObject]) {
            self.notification = notification
        }
        
        func process(application: UIApplication, notification: [NSObject : AnyObject], fetchCompletionHandler: (UIBackgroundFetchResult -> Void)?) {}
    }
    
    class CKInfoProcessor: NSObject, CKPushNotificationProcessor {
        
        var notification: [NSObject: AnyObject]
        
        static func processorType() -> String {
            return "info"
        }
        
        required init(notification: [NSObject : AnyObject]) {
            self.notification = notification
        }
        
        func process(application: UIApplication, notification: [NSObject : AnyObject], fetchCompletionHandler: (UIBackgroundFetchResult -> Void)?) {}
    }
    
}
