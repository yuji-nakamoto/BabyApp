//
//  AppDelegate.swift
//  BabyApp
//
//  Created by yuji nakamoto on 2020/10/28.
//

import UIKit
import Firebase
import UserNotifications
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    var user = User()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        fetchUser()
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback, mode: .default)
        } catch  {
            fatalError("Error set category")
        }
        
        do {
            try session.setActive(true)
        } catch  {
            fatalError("Error session")
        }
        
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.sound, .badge, .alert]
            
            current.requestAuthorization(options: options) { (granted, error) in
                if error != nil {
                    
                } else {
                    Messaging.messaging().delegate = self
                    current.delegate = self
                    
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            let types: UIUserNotificationType = [.sound, .badge, .alert]
            let setting = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings(setting)
            application.registerForRemoteNotifications()
        }
        
        return true
    }
    
    private func fetchUser() {
        UserDefaults.standard.removeObject(forKey: IS_LOGIN)
        guard Auth.auth().currentUser != nil else { return }
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            UserDefaults.standard.set(true, forKey: IS_LOGIN)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID3: \(messageID)")
        }
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            if notification.request.content.title == "フォロー" {
                
                let dict = [MYPAGE_BADGE_COUNT: user.myPageBadgeCount + 1,
                            APP_BADGE_COUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            } else if notification.request.content.title == "投稿" {
                
                let dict = [COMMUNITY_BADGE_COUNT: user.communityBadgeCount + 1,
                            APP_BADGE_COUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            }
        }
        completionHandler([.sound, .badge, .banner, .list])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID4: \(messageID)")
        }
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            if response.notification.request.content.title == "フォロー" {
                
                let dict = [MYPAGE_BADGE_COUNT: user.myPageBadgeCount + 1,
                            APP_BADGE_COUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            } else if response.notification.request.content.title == "投稿" {
                
                let dict = [COMMUNITY_BADGE_COUNT: user.communityBadgeCount + 1,
                            APP_BADGE_COUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            }
        }
        print(userInfo)
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
