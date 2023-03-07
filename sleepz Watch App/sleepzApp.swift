//
//  sleepzApp.swift
//  sleepz Watch App
//
//  Created by Burhan Drak Sibai on 1/31/23.
//

import SwiftUI

@main
struct sleepz_Watch_AppApp: App {
    @WKExtensionDelegateAdaptor private var extensionDelegate: ExtensionDelegate

    
//    @StateObject var workoutManager = WorkoutManager()
    
    @SceneBuilder var body: some Scene {
        WindowGroup{
            NavigationView {
                //StartView()
                HapticsView()
            }
           
        }
    }
}
