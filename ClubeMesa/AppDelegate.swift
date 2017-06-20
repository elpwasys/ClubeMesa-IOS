//
//  AppDelegate.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 14/04/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let pushTokenKey = "\(AppDelegate.self).pushToken"
    
    var pushToken: String? {
        didSet {
            if self.pushToken == nil {
                UserDefaults.standard.removeObject(forKey: pushTokenKey)
            } else {
                UserDefaults.standard.set(self.pushToken, forKey: pushTokenKey)
            }
        }
    }
    
    lazy var pushTokenNotificationName: Notification.Name = {
        return Notification.Name(rawValue: "\(AppDelegate.self).pushTokenNotificationName")
    }()
    
    lazy var didBecomeActiveNotificationName: Notification.Name = {
        return Notification.Name(rawValue: "\(AppDelegate.self).didBecomeActiveNotificationName")
    }()
    
    func clear() {
        self.pushToken = nil
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        URLProtocol.registerClass(AppURLProtocol.self)
        
        let color = #colorLiteral(red: 0.2318026125, green: 0.003526003798, blue: 0.05918241292, alpha: 1)
        UITextField.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = color
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: Voucher.className()) { oldObject, newObject in
                        newObject!["dataUtilizacao"] = nil
                    }
                }
            }
        )
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NotificationCenter.default.post(name: didBecomeActiveNotificationName, object: application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var pushToken = String()
        for i in 0..<deviceToken.count {
            pushToken.append(String(format: "%02.2hhx", arguments: [deviceToken[i]]))
        }
        if TextUtils.isNotBlank(pushToken) {
            self.pushToken = pushToken
            NotificationCenter.default.post(name: pushTokenNotificationName, object: pushToken)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let type = userInfo["type"] as? String {
            if type == "web", let dictionary = userInfo["data"] as? [String: String] {
                if let link = dictionary["link"] {
                    UserDefaults.standard.set(link, forKey: WebViewController.linkKey)
                }
            }
        }
    }
}
