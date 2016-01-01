//
//  CKWarningNotificationProcessor.m
//  CKNotificationKit
//
//  Created by Kevin Chen on 12/31/15.
//  Copyright © 2015 Kevin Chen. All rights reserved.
//

#import "CKWarningNotificationProcessor.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CKWarningNotificationProcessor ()

@property (nonatomic, copy) NSDictionary *notification;

@end

@implementation CKWarningNotificationProcessor

- (nonnull instancetype)initWithNotification:(NSDictionary * __nonnull)notification {
    self = [super init];
    if (self) {
        _notification = [notification copy];
    }
    
    return self;
}

+ (NSString * __nonnull)processorType {
    return @"warning";
}

- (void)process:(UIApplication * __nonnull)application notification:(NSDictionary * __nonnull)notification fetchCompletionHandler:(void (^ __nullable)(UIBackgroundFetchResult))fetchCompletionHandler {
    
    switch (application.applicationState) {
        case UIApplicationStateActive: {
            NSString *message = notification[@"message"];
            if (message) {
                [SVProgressHUD showErrorWithStatus:message];
            }
            
            break;
        }
            
        case UIApplicationStateBackground:
            
            break;
            
        case UIApplicationStateInactive:
            break;
            
        default:
            break;
    }
    
    if (fetchCompletionHandler) {
        fetchCompletionHandler(UIBackgroundFetchResultNoData);
    }
}

@end
