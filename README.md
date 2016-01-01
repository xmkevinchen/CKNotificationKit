# CKNotificationKit

## Description

CKNotificationKit is just a simple idea about how to organize the processing code of Push Notification.   

The basic mechanism is **Registration and Processing**.

Briefly, based on the requirement,  
1. Several notification processors could be created, which are adopt `CKPushNotificationProcessor`.    
2. Register processors to `CKPushNotificationRouter`, usually when App is launched, or will be launched.    
3. Use `CKPushNotificationRouter` at `UIApplicationDelegate` relative methods.    

## Create Processor

### CKPushNotificationProcessor

In order to work around with `CKPushNotificationRouter`, all processors should adopt `CKPushNotificationProcessor`

```swift

@objc public protocol CKPushNotificationProcessor : class {

    static func processorType() -> String

    init(notification:[NSObject: AnyObject])

    func process(application: UIApplication, notification:[NSObject: AnyObject], fetchCompletionHandler:(UIBackgroundFetchResult -> Void)?)
}

```

Let's take this push notification payload as sample

```json

{
    "aps" : {
        "alert" : {
            "title" : "Greeting",
            "body" : "Hello, friend",
            "action-loc-key" : "PLAY"
        },
        "badge" : 5
    },    
    "messageType" : "greeting",
    "message": "Hello, friend",
    "title": "Greeting"
}

```


### Sample Processor

```swift
class CKGreetingNotificationProcessor: NSObject, CKPushNotificationProcessor {

    var notification: [NSObject : AnyObject]

    static func processorType() -> String {
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
            print("====> Received greeting push notification when application is in background")

        case .Inactive:
            print("====> Received greeting push notification when application is inactive")
        }

        fetchCompletionHandler?(.NoData)
    }
}

```

As sample processor shown above,  
1. The `static func processorType() -> String` indicates which type of push notification could be processed with this processor.  
2. When App receives push notification, `CKPushNotificationRouter` would look up its registered processors, pick up correct one and generate one new fresh instance of processor.  
3. After getting an instance of correct processor, `CKPushNotificationRouter` would call processor's `func process(application: UIApplication, notification: [NSObject : AnyObject], fetchCompletionHandler: (UIBackgroundFetchResult -> Void)?)` method, so this is the right place to put the processing logic of push notification.  


## Register Processor

Usually, processors would be registered when app is launched like this

```swift

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.

    CKPushNotificationRouter.sharedRouter.register(processor: CKGreetingNotificationProcessor.self)    

    ...

    return true
}

```

## Router

`CKPushNotificationRouter` should be called when app receives the push notification, like

```swift

func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    if !CKPushNotificationRouter.sharedRouter.route(application, notification: userInfo, fetchCompletionHandler: nil) {
        print("====> Received unknown notification \(userInfo)")
    }
}

```

or

```swift

func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    if !CKPushNotificationRouter.sharedRouter.route(application, notification: userInfo, fetchCompletionHandler: completionHandler) {
        print("====> Received unknown notification \(userInfo)")
    }
}

```

For picking up correct processor, `CKPushNotificationRouter` has two simple ways to find correct push notification type  
1. property `messageTypeKey`, default value is `messageType`  
2. property `messageTypeProcessor` which is a closure, default value is nil  

When `messageTypeProcessor` isn't set, `CKPushNotificationRouter` uses `messageTypeKey` value to find the type directly in the dictionary of push notification. When `messageTypeProcessor` is set, `CKPushNotificationRouter` leaves the logic for you.

Still take this json payload as sample

```json

{
    "aps" : {
        "alert" : {
            "title" : "Greeting",
            "body" : "Hello, friend",
            "action-loc-key" : "PLAY"
        },
        "badge" : 5
    },    
    "type" : "greeting",
    "message": "Hello, friend",
    "title": "Greeting"
}

```

When using `messageTypeKey`, because the default value of it is `messageType`, in order to get the correct type, the value of `messageType` should be assigned as `type`.


When using `messageTypeProcessor`, the closure should be assigned as

```swift

CKPushNotificationRouter.sharedRouter.messageTypeProcessor = { notification in
    return notification["type"] as! String
}

```

### Notice

When the value retrieved via `messageTypeKey` or `messageTypeProcessor` from push notification matches the value returned from `static func processorType() -> String` in `CKPushNotificationProcessor`, router would pick up this processor as correct one.
