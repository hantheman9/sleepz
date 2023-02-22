//
//  AlarmEdit.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-02-18.
//

import Foundation
import SwiftUI
import CoreData


struct AlarmEditStartTimeView: View {

    @Binding var alarm: AlarmInfo
    @State var currAlarmInfo = CurrentAlarmInfo()
    
    func setupCurrInfo() {
        currAlarmInfo.currStartHour = Int(alarm.startHour)
        currAlarmInfo.currStartMinute = Int(alarm.startMinute)
        currAlarmInfo.currStartMeridiem = alarm.startMeridiem ?? "am"

        currAlarmInfo.currEndHour = Int(alarm.endHour)
        currAlarmInfo.currEndMinute = Int(alarm.endMinute)
        currAlarmInfo.currEndMeridiem = alarm.endMeridiem ?? "am"
    }

    var body: some View {
        VStack {
            Text("Set wake up window end")
            TimePickerView(currAlarmInfo: $currAlarmInfo, isStart: true)
            OrangeButton(content: {AlarmEditEndTimeView(alarm: $alarm, currAlarmInfo: $currAlarmInfo)}, action: {})
        }.onAppear(perform: {
            setupCurrInfo()
            print("Current start/end time:")
            print(currAlarmInfo.currStartHour)
            print(currAlarmInfo.currEndHour)

        })
    }
}

struct AlarmEditEndTimeView: View {
    @Binding var alarm: AlarmInfo
    @Binding var currAlarmInfo: CurrentAlarmInfo
    let coreDM = PersistentController()
    
    
    var body: some View {
        VStack{
            Text("Set wake up window end")
            TimePickerView(currAlarmInfo: $currAlarmInfo, isStart: false)
            OrangeButton(content: {AlarmHome(coreDM: coreDM)}, action: {
                alarm.startHour = Int32(currAlarmInfo.currStartHour)
                alarm.startMinute = Int32(currAlarmInfo.currStartMinute)
                alarm.startMeridiem = currAlarmInfo.currStartMeridiem
                
                alarm.endHour = Int32(currAlarmInfo.currEndHour)
                alarm.endMinute = Int32(currAlarmInfo.currEndMinute)
                alarm.endMeridiem = currAlarmInfo.currEndMeridiem
            
                print("Edited start/end time:")
                print(currAlarmInfo.currStartHour)
                print(currAlarmInfo.currEndHour)
                
                coreDM.updateAlarm()
            })
        }
//        OrangeButton(content: {AlarmEndTimeView()})
    }
}

//struct AlarmEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let alarm = AlarmInfo()
//        let coreDM = PersistentController()
//        
//        AlarmEditStartTimeView(alarm: $alarm, coreDM: PersistentController())
//    }
//}


