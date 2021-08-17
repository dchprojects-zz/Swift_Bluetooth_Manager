//
//  SBMBluetoothManager.swift
//  Swift_Bluetooth_Manager
//
//  Created by Dmytro Chumakov on 17.08.2021.
//

import CoreBluetooth

protocol SBMBluetoothManagerProtocol {
    func isPoweredOn() -> Bool
    func scanForPeripherals(withServices: [CBUUID]?, options: [String : Any]?)
    func stopScan()    
}

final class SBMBluetoothManager: NSObject, SBMBluetoothManagerProtocol {
    
    fileprivate let cbCentralManager: CBCentralManager
    
    internal var centralManagerDidUpdateState: ((CBManagerState) -> Void)?
    
    init(cbCentralManager: CBCentralManager) {
        self.cbCentralManager = cbCentralManager
    }
    
}

// MARK: - SBMBluetoothManagerProtocol
extension SBMBluetoothManager {
    
    func isPoweredOn() -> Bool {
        return cbCentralManager.state == .poweredOn
    }
    
    func scanForPeripherals(withServices services: [CBUUID]?, options: [String : Any]?) {
        cbCentralManager.scanForPeripherals(withServices: services, options: options)
    }
    
    func stopScan() {
        cbCentralManager.stopScan()
    }
    
}
