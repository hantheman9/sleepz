//
//  AlarmView.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/1/23.
//

import Foundation
import SwiftUI
import CoreData

/***
 
 For alarmList,
 - isActive (boolean)
 - startTime (integer)
 - endTime (integer)
 - durationRange (integer)
 - days (list of strings)
  
 */

    

struct AlarmHome: View {
    
    @FetchRequest (
        entity: AlarmInfo.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmInfo.dateAdded, ascending: false)]
    )

    var results: FetchedResults<AlarmInfo>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(results) { item in
                    HStack {
                        NavigationLink(
                            destination: Text(item.hour! + ":" + item.minute!),
                            label: {Text(item.hour! + ":" + item.minute!)
                            }
                        )
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }
                }
        
                NavigationLink(
                    destination: AlarmStartTimeView(),
                    label: {
                        Text("New Alarms")
                    }
                )
            }
            .overlay(
                Text(results.isEmpty ? "No alarms set" : "")
            )
            .navigationTitle("My alarms")
            .navigationBarBackButtonHidden(true)
        }
        
//        NavigationStack {
//            ScrollView{
//                VStack{
//                    NavigationLink(
//                        destination: AlarmStartTimeView(),
//                        label: {
//                            Text("New Alarms")
//                        }
//                    )
//                }
//            }
//            .navigationTitle("My alarms")
//            .navigationBarBackButtonHidden(true)
//        }
    }
}

struct AlarmStartTimeView: View {
    var body: some View {
        VStack {
            Text("Set wake up window start")
            TimePickerView()
//            OrangeButton(content: {AlarmEndTimeView()})
        }
    }
}

struct AlarmEndTimeView: View {
    var body: some View {
        Text("Set wake up window end")
        TimePickerView()
        OrangeButton(content: {AlarmEndTimeView()})
    }
}

struct AlarmDayView: View {
    var body: some View {
        Text("Set schedule")
        GreenButton(content: {AlarmHome()})
        
    }
}

struct AlarmHome_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHome()
    }
}




