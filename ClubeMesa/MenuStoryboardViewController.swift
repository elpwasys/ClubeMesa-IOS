//
//  MenuStoryboardViewController.swift
//  ClubeMesa
//
//  Created by Everton Luiz Pascke on 18/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit
import UserNotifications

class MenuStoryboardViewController: ClubMesaViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        self.initObservers()
        self.askPushToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initObservers() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            let center = NotificationCenter.default
            center.addObserver(forName: delegate.pushTokenNotificationName, object: nil, queue: nil) { notification in
                if let pushToken = notification.object as? String {
                    self.answerPushToken(pushToken: pushToken)
                }
            }
            center.addObserver(forName: delegate.didBecomeActiveNotificationName, object: nil, queue: nil) { notification in
                self.askPushToken()
            }
        }
    }
    
    private func askPushToken() {
        if let dispositivo = Dispositivo.current {
            if dispositivo.pushToken == nil {
                if let delegate = UIApplication.shared.delegate as? AppDelegate, let pushToken = delegate.pushToken {
                    self.answerPushToken(pushToken: pushToken)
                } else {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
                        if granted {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
        }
    }
    
    private func answerPushToken(pushToken: String) {
        let observable = DispositivoService.Async.atualizar(pushToken: pushToken)
        prepare(for: observable)
            .subscribe(
                onError: { error in
                    self.handle(error)
            }
            ).addDisposableTo(disposableBag)
    }
    
    fileprivate func handleNotification(_ link: String) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "Scene.Web") as! WebViewController
        controller.link = link
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MenuStoryboardViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let request = notification.request
        let content = request.content
        let userInfo = content.userInfo
        if let type = userInfo["type"] as? String {
            if type == "web", let dictionary = userInfo["data"] as? [String: String] {
                if let link = dictionary["link"] {
                    self.handleNotification(link)
                }
            }
        }
        completionHandler()
    }
}
