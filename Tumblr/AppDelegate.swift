//
//  AppDelegate.swift
//  Tumblr
//
//  Created by Alex Demchenko on 27/01/2018.
//  Copyright © 2018 Alex Demchenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let viewModel = UsernameViewModel()
        let rootViewController = UsernameViewController(viewModel: viewModel)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        window.makeKeyAndVisible()

        self.window = window

        UINavigationBar.appearance().barTintColor = .background
        UINavigationBar.appearance().tintColor = .darkGray
        UINavigationBar.appearance().shadowImage = UIImage()

        return true
    }
}
