//
//  RootViewController.swift
//  Swift_Bluetooth_Manager
//
//  Created by Dmytro Chumakov on 17.08.2021.
//

import UIKit

struct RootViewController {
    
    static var viewController: UIViewController {
        let viewController: UIViewController = .init()
        viewController.view.backgroundColor = .white
        viewController.title = "Root View Controller"
        return UINavigationController.init(rootViewController: viewController)
    }
    
}
