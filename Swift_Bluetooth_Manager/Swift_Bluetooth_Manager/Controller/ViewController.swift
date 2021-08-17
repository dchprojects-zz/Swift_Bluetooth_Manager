//
//  ViewController.swift
//  Swift_Bluetooth_Manager
//
//  Created by Dmytro Chumakov on 17.08.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    fileprivate var bluetoothManager: SBMBluetoothManagerProtocol
    
    init(bluetoothManager: SBMBluetoothManagerProtocol) {
        self.bluetoothManager = bluetoothManager
        super.init(nibName: nil, bundle: nil)
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
}

// MARK: - Start Scanning
fileprivate extension ViewController {
    
    func scanForPeripherals() {
        bluetoothManager.scanForPeripherals(withServices: Constants.BLE.servicesForScan,
                                            options: Constants.BLE.optionsForScanPeripherals)
    }
    
}

// MARK: - Configure UI
fileprivate extension ViewController {
    
    func configureUI() {
        configureTitle()
        configureView()
    }
    
    func configureView() {
        self.view.backgroundColor = .white
    }
    
    func configureTitle() {
        self.title = String(describing: Self.self)
    }
    
}

// MARK: - Subscribe
fileprivate extension ViewController {
    
    func subscribe() {
        bluetoothManager.centralManagerDidUpdateState = { [weak self] (state) in
            if (state == .poweredOn) {
                self?.scanForPeripherals()
            } else {
                return
            }
        }
    }
    
}
