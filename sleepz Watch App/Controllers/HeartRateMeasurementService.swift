

import Foundation
import SwiftUI
import HealthKit

class HeartRateMeasurementService: ObservableObject {
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @Published var currentHeartRate: Int = 0
    
    @Published var minHeartRate: Int = -1
    @Published var maxHeartRate: Int = 0
    
    init() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {

        
    //    This block of code will create a fake workout session to produce heart rate data

//        // Create a mock health store
//        let healthStore = HKHealthStore()
//        healthStore.requestAuthorization(toShare: nil, read: [HKObjectType.workoutType(), HKObjectType.quantityType(forIdentifier: .heartRate)!]) { (success, error) in
//            if let error = error {
//                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
//            }
//        }
//
//        // Create a workout configuration
//        let workoutConfiguration = HKWorkoutConfiguration()
//        workoutConfiguration.activityType = .running
//        workoutConfiguration.locationType = .outdoor
//
//        // Create a workout session
//        let workoutSession = try! HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
//
//        // Create a live workout builder
//        let workoutBuilder = workoutSession.associatedWorkoutBuilder()
//        workoutBuilder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)
//
//        // Start the workout session
//        workoutSession.startActivity(with: Date())

//        This block of code will create a fake workout session to produce heart rate data
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            self.process(samples, type: quantityTypeIdentifier)
        }
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
                print("The current heart rate is")
                print(lastHeartRate)
            }
            DispatchQueue.main.async {
                self.currentHeartRate = Int(lastHeartRate)
                if self.maxHeartRate < self.currentHeartRate {
                    self.maxHeartRate = self.currentHeartRate
                }
                if self.minHeartRate == -1 || self.minHeartRate > self.currentHeartRate {
                    self.minHeartRate = self.currentHeartRate
                }
            }
        }
    }
}
