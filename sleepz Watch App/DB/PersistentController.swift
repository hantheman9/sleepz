//
//  PersistentController.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-02-04.
//

import Foundation
import CoreData
import SwiftUI

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
    
    func getAlarm(alarmId: NSManagedObjectID) -> NSManagedObject {
        var alarmObject: NSManagedObject = NSManagedObject()
        do {
            alarmObject = try container.viewContext.existingObject(with: alarmId);
        } catch {
            print("could not fetch alarm with id" + alarmId.uriRepresentation().absoluteString)
        }
        return alarmObject
    }
    
    func updateAlarm(alarmId: NSManagedObjectID, alarmInfo: CurrentAlarmInfo) {
        do {
            let alarmObject = getAlarm(alarmId: alarmId);
            alarmObject.setValue(Int32(alarmInfo.currStartHour), forKey: "startHour");
            alarmObject.setValue(Int32(alarmInfo.currStartMinute), forKey: "startMinute");
            alarmObject.setValue(alarmInfo.currStartMeridiem, forKey: "startMeridiem");
            
            alarmObject.setValue(Int32(alarmInfo.currEndHour), forKey: "endHour");
            alarmObject.setValue(Int32(alarmInfo.currEndMinute), forKey: "endMinute");
            alarmObject.setValue(alarmInfo.currEndMeridiem, forKey: "endMeridiem");
            
            alarmObject.setValue(true, forKey: "isActive");
            
            try container.viewContext.save()
            print("did save")
        } catch {
            print("didn't save")
            container.viewContext.rollback()
        }
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save alarm \(error)")
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
        alarm.isActive = true
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save alarm \(error)")
        }
    }
    
    func deleteAlarm(alarm: AlarmInfo) {
        
        container.viewContext.delete(alarm)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Failed to save context \(error)")
        }
        
    }
    
//    func toggleActive(of alarm: AlarmInfo) -> Binding<Bool> {
//
//        updateAlarm()
//
//            let binding = Binding<Bool>(get: { () -> Bool in
//                return alarm.isActive != nil
//
//            }) { (newValue) in
//                // save to database
//                toggleActive(of: alarm)
//            }
//            return binding
//        }
    
}
