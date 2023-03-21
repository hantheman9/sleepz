//
//  accelerometerService.swift
//  HeartRate
//
//  Created by Burhan Drak Sibai on 2/22/23.
//
import Foundation
import CoreMotion
import Combine
import SwiftUI

class accelerometerService: NSObject, ObservableObject {
    var motionManager: CMMotionManager?
    
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    @Published var collectiveAcc = ""
    
    private var samplingFrequency = 50.0
    
    var timer = Timer()
    
    override init() {
        super.init()
        self.motionManager = CMMotionManager()
        self.startUpdate(50.0)
    }
    
    @objc private func startLogSensor() {

        
        if let data = motionManager?.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            self.accX = x
            self.accY = y
            self.accZ = z
            let xs = x*x
            let ys = y*y
            let zs = z*z
            let collsq = sqrt(xs+ys+zs)
            self.collectiveAcc = String(format: "%.4f", collsq)
//            print("CURRENT ACCELERATION")
//            print(String(format: "%.4f", xs))
//            print(String(format: "%.4f", ys))
//            print(String(format: "%.4f", zs))
        }
        else {
            self.accX = Double.nan
            self.accY = Double.nan
            self.accZ = Double.nan
            self.collectiveAcc = ""
        }
        
        
        if let data = motionManager?.deviceMotion {
            let x = data.rotationRate.x
            let y = data.rotationRate.y
            let z = data.rotationRate.z
            
            self.gyrX = x
            self.gyrY = y
            self.gyrZ = z
            
        }
        else {
            self.gyrX = Double.nan
            self.gyrY = Double.nan
            self.gyrZ = Double.nan
        }
        
//        print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ))")
    }
    
    func startUpdate(_ freq: Double) {
        if motionManager!.isAccelerometerAvailable {
            motionManager?.startAccelerometerUpdates()
        }
        
        
        if motionManager!.isDeviceMotionAvailable {
            motionManager?.startDeviceMotionUpdates()
        }
        
        self.samplingFrequency = freq
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0 / freq,
                           target: self,
                           selector: #selector(self.startLogSensor),
                           userInfo: nil,
                           repeats: true)
    }
    
    func stopUpdate() {
        self.timer.invalidate()
        
        if motionManager!.isAccelerometerActive {
            motionManager?.stopAccelerometerUpdates()
        }
        
        if motionManager!.isGyroActive {
            motionManager?.stopGyroUpdates()
        }
        
    }
}


