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
    func connect(_ peripheral: CBPeripheral, options: [String : Any]?)
    func stopScan()
    var centralManagerDidUpdateState: ((CBManagerState) -> Void)? { get set }
}

final class SBMBluetoothManager: NSObject, SBMBluetoothManagerProtocol {
    
    fileprivate var cbCentralManager: CBCentralManager!
    fileprivate var miBand4Peripheral: CBPeripheral!
    
    static let shared: SBMBluetoothManagerProtocol = SBMBluetoothManager.init(cbCentralManager: nil)
    
    internal var centralManagerDidUpdateState: ((CBManagerState) -> Void)?
    
    override init() {
        super.init()
    }
    
    convenience init(cbCentralManager: CBCentralManager? = nil) {
        self.init()
        
        if cbCentralManager == nil {
            
            let queue: DispatchQueue = .init(label: String.init(describing: Self.self))
            
            
            self.cbCentralManager = CBCentralManager(delegate: self,
                                                     queue: queue,
                                                     options: Constants.BLE.cbCentralManagerOptions)
            
        } else {
            self.cbCentralManager = cbCentralManager
        }
        
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
    
    func connect(_ peripheral: CBPeripheral, options: [String : Any]?) {
        cbCentralManager.connect(peripheral, options: options)
    }
    
}

// MARK: - CBCentralManagerDelegate
extension SBMBluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        debugPrint(#function, Self.self)
        
        switch central.state {
        case .unknown:
            debugPrint("central.state is .unknown")
        case .resetting:
            debugPrint("central.state is .resetting")
        case .unsupported:
            debugPrint("central.state is .unsupported")
        case .unauthorized:
            debugPrint("central.state is .unauthorized")
        case .poweredOff:
            debugPrint("central.state is .poweredOff")
        case .poweredOn:
            debugPrint("central.state is .poweredOn")
        @unknown default:
            debugPrint("unknown")
        }
        
        centralManagerDidUpdateState?(central.state)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard (peripheral.identifier == Constants.BLE.MI_BAND_4_DEVICE_IDENTIFIER) else { return }
        self.miBand4Peripheral = peripheral
        self.miBand4Peripheral.delegate = self
        self.stopScan()
        self.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.miBand4Peripheral.discoverServices(Constants.BLE.discoverServices)
        debugPrint(#function, Self.self)
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint(#function, Self.self)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - CBPeripheralDelegate
extension SBMBluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            debugPrint(#function, Self.self, "service: ", service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            debugPrint(#function, Self.self, "characteristic: ", characteristic)
            
            if characteristic.properties.contains(.read) {
                debugPrint(#function, Self.self, "\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                debugPrint(#function, Self.self, "\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case Constants.BLE.UUID_CHARACTERISTIC_HEART_RATE_DATA:
            debugPrint(#function, Self.self, "UUID_CHARACTERISTIC_HEART_RATE_DATA: ", "characteristic.value: ", characteristic.value)
        case Constants.BLE.UUID_CHARACTERISTIC_HEART_RATE_CONTROL:
            debugPrint(#function, Self.self, "UUID_CHARACTERISTIC_HEART_RATE_CONTROL: ", "characteristic.value: ", characteristic.value)
        default:
            debugPrint(#function, Self.self, "Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
}
