//
//  SleepStageService.swift
//  HeartRate
//
//  Created by Burhan Drak Sibai on 2/22/23.
//

import Foundation
import HealthKit
import SwiftUI


class SleepStageService: ObservableObject {
    
    
    let healthStore = HKHealthStore()
    
    @Published var sleepStage = "Awake"

    init() {
        requestAuthorization()
        startMonitoring()
    }

    func requestAuthorization() {
        let types = Set([HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!])

        healthStore.requestAuthorization(toShare: nil, read: types) { (success, error) in
            if let error = error {
                print("Error requesting authorization for sleep analysis: \(error.localizedDescription)")
            } else {
                print("Authorization granted for sleep analysis")
            }
        }
    }

    func startMonitoring() {
        // Create a sleep query with an observer to monitor for changes
        let query = HKObserverQuery(sampleType: HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                print("Error monitoring sleep data: \(error.localizedDescription)")
                return
            }

            // Call a method to fetch the latest sleep data
            self.fetchSleepData()
        }

        // Register the query with HealthKit
        healthStore.execute(query)
    }

    func fetchSleepData() {
        // Create a query to fetch the latest sleep data
        let startDate = Date().addingTimeInterval(-1800) // start date 24 hours ago
        let endDate = Date() // end date now
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                print("Error fetching sleep data: \(error.localizedDescription)")
                return
            }

            if let sample = samples?.first as? HKCategorySample {
                // Get the sleep data from the sample
                let value = sample.value
                self.sleepStage = "Awake"
                let startDate = sample.startDate
                let endDate = sample.endDate

                // Process the sleep data as needed
                print("Sleep data: value=\(value), startDate=\(startDate), endDate=\(endDate)")
            } else {
//                print("No sleep data available")
            }
        }

        // Execute the query
        healthStore.execute(query)
    }
    
//    private var healthStore = HKHealthStore()
//
//    @Published var sleepStage = 0
//
//    init() {
//        autorizeHealthKit()
//        getSleepStage(catagoryTypeIdentifier: .sleepAnalysis)
//    }
//
//    func autorizeHealthKit() {
//        let healthKitTypes: Set = [
//        HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!]
//
//        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
//    }
//
//
//    func getSleepStage(catagoryTypeIdentifier: HKCategoryTypeIdentifier) {
//
//        print("TEST POINTTT")
//
//        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
//        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
//            query, samples, deletedObjects, queryAnchor, error in
//            guard let samples = samples as? [HKCategorySample] else {
//                return
//            }
//            self.process(samples, type: catagoryTypeIdentifier)
//        }
//        let query = HKAnchoredObjectQuery(type: HKObjectType.categoryType(forIdentifier: catagoryTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
//        query.updateHandler = updateHandler
//        healthStore.execute(query)
//    }
//
//
//    private func process(_ samples: [HKCategorySample], type: HKCategoryTypeIdentifier) {
//        print(samples)
//        for sample in samples {
//            if type == .sleepAnalysis {
//                print("THE VAL ISSSS")
//                print(sample.value)
//                self.sleepStage = sample.value
//
//            }
//
//        }
//    }

}
