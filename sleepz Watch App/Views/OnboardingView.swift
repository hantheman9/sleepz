//
//  DataAllowanceView.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-03-04.
//

import SwiftUI
import Foundation
import CoreMotion
import HealthKit

struct OnboardingView: View {
    let motionActivityManager = CMMotionActivityManager()


    let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
    let healthStore = HKHealthStore()
    
    var body: some View {
        LaunchScreen()
            .onAppear(perform: {
                healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                    if !success {
                        print("\(error)")
                }
            }
        })
    }
    
    func checkMotionPermission(closure: @escaping (Bool) -> Void) {
        switch CMMotionActivityManager.authorizationStatus() {
        case .authorized:
            closure(true)
        case .notDetermined:
            let activityManager = CMMotionActivityManager()
            activityManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { (activity, error) in
                let auth = CMPedometer.authorizationStatus()
                switch auth {
                case .authorized:
                    closure(true)
                default:
                    closure(false)
                }
            }
        default:
            closure(false)
        }
    }
}

struct LaunchScreen: View {
    var body: some View {
        VStack {
            Text("Welcome to Sleepz")
                .fontWeight(.heavy)
            Image("LaunchIcon")
                .resizable()
                .scaledToFit()
            OrangeButton(content: {AlarmHome(coreDM: PersistentController())}, action: {}).accessibilityIdentifier("nextButton")
        }.padding(EdgeInsets())
    }
}





struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
