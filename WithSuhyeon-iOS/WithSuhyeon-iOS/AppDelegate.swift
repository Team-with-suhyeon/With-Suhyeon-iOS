//
//  AppDelegate.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 6/3/25.
//

import UIKit

import Firebase
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            print("🔔 Notification permission granted: \(granted)")
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // APNs 토큰 수신
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("✅ APNs 등록 성공: \(deviceToken)")
        
        Messaging.messaging().apnsToken = deviceToken
        
        // ✅ APNs 토큰이 설정된 이후에 FCM 토큰 요청
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("❌ FCM 토큰 가져오기 실패: \(error.localizedDescription)")
                } else if let token = token {
                    print("📱 (정상 요청) FCM Token: \(token)")
                    FCMService.sendFCMTokenToServer(token)
                }
            }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ APNs 등록 실패: \(error.localizedDescription)")
    }
    
    // FCM 토큰 수신
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("=========📱 FCM Token: \(fcmToken ?? "")==========")
        // 서버로 토큰 전송 로직 추가
        if let token = fcmToken {
            FCMService.sendFCMTokenToServer(token)
        }
    }
    
    // 포그라운드 수신 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    //백그라운드에서 알림 클릭 시 화면 이동(옵셔널)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("🔔 userInfo: \(userInfo)")
        
        // 예: 특정 키가 있다면 특정 화면으로 이동
        if let type = userInfo["type"] as? String {
            print("푸시 타입: \(type)")
            
            //            DispatchQueue.main.async {
            //                if type == "chat" {
            //                    // 예: 특정 채팅방으로 이동
            //                    NotificationCenter.default.post(name: .navigateToChat, object: nil)
            //                }
            //            }
        }
        
        completionHandler()
    }
}
