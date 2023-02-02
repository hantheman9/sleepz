//
//  AlarmView.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/1/23.
//

import Foundation
import SwiftUI

/***
 
 For alarmList,
 - isActive (boolean)
 - startTime (integer)
 - endTime (integer)
 - durationRange (integer)
 - days (list of strings)
  
 */

struct AlarmHome: View {
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    NavigationLink(
                        destination: AlarmStartTimeView(),
                        label: {
                            Text("New Alarms")
                        }
                    )
                }
            }
            .navigationTitle("My alarms")
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct AlarmStartTimeView: View {
    var body: some View {
        VStack {
            Text("Set wake up window start")
            TimePickerView()
            OrangeButton(content: {AlarmEndTimeView()})
        }
    }
}

struct AlarmEndTimeView: View {
    var body: some View {
        Text("Set wake up window end")
        TimePickerView()
        OrangeButton(content: {AlarmDayView()})
        
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




