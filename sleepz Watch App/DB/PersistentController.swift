//
//  PersistentController.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-02-04.
//

import Foundation
import CoreData

struct PersistentController {
    static let shared = PersistentController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func getAllAlarms() -> [AlarmInfo] {

        let fetchRequest: NSFetchRequest<AlarmInfo> = AlarmInfo.fetchRequest()

        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func updateAlarm() {
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
        }
    }
    
    func saveAlarm(currAlarm: CurrentAlarmInfo) {
        let alarm = AlarmInfo(context: container.viewContext)
        
        alarm.startHour = Int32(currAlarm.currStartHour)
        alarm.startMinute = Int32(currAlarm.currStartMinute)
        alarm.startMeridiem = currAlarm.currStartMeridiem
        
        alarm.endHour = Int32(currAlarm.currEndHour)
        alarm.endMinute = Int32(currAlarm.currEndMinute)
        alarm.endMeridiem = currAlarm.currEndMeridiem
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save alarm \(error)")
        }
    }
    
}
