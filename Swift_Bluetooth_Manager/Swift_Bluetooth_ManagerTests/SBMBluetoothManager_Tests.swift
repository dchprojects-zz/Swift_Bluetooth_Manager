//
//  SBMBluetoothManager_Tests.swift
//  Swift_Bluetooth_ManagerTests
//
//  Created by Dmytro Chumakov on 17.08.2021.
//

import XCTest
import CoreBluetooth

@testable import Swift_Bluetooth_Manager

final class SBMBluetoothManager_Tests: XCTestCase {
    
    fileprivate var bluetoothManager: SBMBluetoothManagerProtocol!
    fileprivate var cbCentralManager: CBCentralManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let queue: DispatchQueue = .init(label: String(describing: Self.self))
        
        let cbCentralManager: CBCentralManager = .init(delegate: self,
                                                       queue: queue,
                                                       options: Constants_For_Tests.cbCentralManagerOptions)
        
        self.cbCentralManager = cbCentralManager
        
        self.bluetoothManager = SBMBluetoothManager.init(cbCentralManager: cbCentralManager)
        
                
        bluetoothManager.scanForPeripherals(withServices: Constants_For_Tests.servicesForScan,
                                            options: Constants_For_Tests.optionsForScanPeripherals)
        
    }
    
}

extension SBMBluetoothManager_Tests {
    
    func test_Bluetooth_Is_Power_On() {
        XCTAssertTrue(cbCentralManager.state == .poweredOn && bluetoothManager.isPoweredOn())
    }
    
}

// MARK: - CBCentralManagerDelegate
extension SBMBluetoothManager_Tests: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        debugPrint(#function, Self.self)
    }
    
}
