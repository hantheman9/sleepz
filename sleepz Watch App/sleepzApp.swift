//
//  sleepzApp.swift
//  sleepz Watch App
//
//  Created by Burhan Drak Sibai on 1/31/23.
//

import SwiftUI
import CoreData


@main
struct sleepz_Watch_AppApp: App {
//    @StateObject var workoutManager = WorkoutManager()

    let container = PersistentController.shared.container
    @SceneBuilder var body: some Scene {
        WindowGroup{
            NavigationView {
                AlarmHome()
            }
            .environment(\.managedObjectContext, container.viewContext)
        }
    }
}

