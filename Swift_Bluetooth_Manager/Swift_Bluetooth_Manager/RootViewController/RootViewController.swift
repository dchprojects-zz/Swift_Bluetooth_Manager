//
//  RootViewController.swift
//  Swift_Bluetooth_Manager
//
//  Created by Dmytro Chumakov on 17.08.2021.
//

import UIKit

struct RootViewController {
    
    static var viewController: UIViewController {
        return UINavigationController.init(rootViewController: ViewController.init(bluetoothManager: SBMBluetoothManager.shared))
    }
    
}
