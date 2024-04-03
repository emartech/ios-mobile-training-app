//
//  Copyright © 2024 Emarsys. All rights reserved.
//

import UIKit
import EmarsysSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        let config = EMSConfig.make { builder in
                builder.setMobileEngageApplicationCode("EMSCF-E601F")
                builder.enableConsoleLogLevels([EMSLogLevel.trace, EMSLogLevel.debug, EMSLogLevel.info, EMSLogLevel.warn, EMSLogLevel.error, EMSLogLevel.basic])
            }
            Emarsys.setup(config: config)

        // Handle push
        UNUserNotificationCenter.current().delegate = Emarsys.push
        
        Emarsys.push.notificationEventHandler = { name, payload in
            print("notificationEventHandler")
            print(name, payload ?? [])
        }

        Emarsys.push.silentMessageEventHandler = { name, payload in
            print(name, payload ?? [])
        }
        
        Emarsys.inApp.eventHandler = { name, payload in
            print(name, payload ?? [])
        }
        
        Emarsys.geofence.eventHandler = { name, payload in
            print(name, payload ?? [])
        }
        
        Emarsys.onEventAction.eventHandler = { name, payload in
            print(name, payload ?? [])
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Emarsys.push.setPushToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            Emarsys.push.handleMessage(userInfo: userInfo)
            completionHandler(.newData)
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            print("Permission granted: \(granted)")
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Permission authorizationStatus: \(settings.authorizationStatus)")
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied, .notDetermined:
                Emarsys.push.clearPushToken()
            @unknown default:
                print("authorization fallback")
            }
        }
    }
}

