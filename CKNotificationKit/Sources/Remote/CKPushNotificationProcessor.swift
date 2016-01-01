//
//  CKPushNotificationProcessor.swift
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

import UIKit

@objc public protocol CKPushNotificationProcessor : class {
    
    static var processorType: String { get }
    
    init(notification:[NSObject: AnyObject])
    
    func process(application: UIApplication, notification:[NSObject: AnyObject], fetchCompletionHandler:(UIBackgroundFetchResult -> Void)?)
}



