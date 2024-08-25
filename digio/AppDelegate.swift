//
//  AppDelegate.swift
//  digio
//
//  Created by Ian Fagundes on 22/08/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window
            let coordinator = AppCoordinator(window: window)
            self.coordinator = coordinator
            coordinator.start()
        }
        return true
    }
}
