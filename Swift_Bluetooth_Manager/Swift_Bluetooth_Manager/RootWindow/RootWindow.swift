//
//  RootWindow.swift
//  Swift_Bluetooth_Manager
//
//  Created by Dmytro Chumakov on 17.08.2021.
//

import UIKit

struct RootWindow {
    
    static var rootWindow: UIWindow {
        let window: UIWindow = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = RootViewController.viewController
        window.makeKeyAndVisible()
        return window
    }
    
}
