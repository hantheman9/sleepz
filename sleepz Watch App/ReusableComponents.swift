//
//  ReusableComponents.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/2/23.
//

import SwiftUI
import CoreData
import WatchKit

struct TimePickerView: View {
    let coreDM: PersistentController = PersistentController()

    
    // Set these as existing alarm info if exists
    @State var selectedStartHour = 1
    @State var selectedStartMinute = 0
    @State var selectedStartMeridiem = ""
    
    @State var selectedEndHour = 1
    @State var selectedEndMinute = 0
    @State var selectedEndMeridiem = ""
    
    @Binding var currAlarmInfo : CurrentAlarmInfo
//    @Binding var existingAlarmInfo : AlarmInfo

//    var nextContent: () -> Content
    var isStart: Bool = true
    
    var hour = 1...12
    var minute = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    var meridiem = ["am","pm"]
    
//    init(@ViewBuilder nextContent: @escaping () -> Content, isStart: Bool = true) {
//        self.isStart = isStart
//        self.nextContent = nextContent
////        self.currAlarmInfo = currAlarmInfo
//        print(self.isStart)
//    }


    // Getting context from environment
    @Environment(\.managedObjectContext) var context
    
    // Presentation
    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack {
            HStack {
                Picker(selection: (self.isStart == true) ? $currAlarmInfo.currStartHour : $currAlarmInfo.currEndHour, label: Text("Hour")) {
                    ForEach(hour, id: \.self) { hourOption in
                        Text(String(hourOption))
                    }
                }
                
                Picker(selection: (self.isStart == true) ? $currAlarmInfo.currStartMinute : $currAlarmInfo.currEndMinute, label: Text("Minute")) {
                    ForEach(minute, id: \.self) { minuteOption in
                        Text(minuteOption >= 10 ? String(minuteOption) : "0" + String(minuteOption))
                    }
                }
                
                Picker(selection: (self.isStart == true) ? $currAlarmInfo.currStartMeridiem : $currAlarmInfo.currEndMeridiem, label: Text("Meridiem")) {
                    ForEach(meridiem, id: \.self) { meridiemOption in
                        Text(meridiemOption)
                    }
                }
            }
//            OrangeButton(content: {self.nextContent()}, action: {
//                if !self.isStart {
//                    coreDM.saveAlarm(currAlarm: currAlarmInfo)
//                }
//            })
        }
    }
    
    func setUpTime() {
        
        if ((self.isStart) == true) {
            currAlarmInfo.currStartHour = selectedStartHour
            currAlarmInfo.currStartMinute = selectedStartMinute
            currAlarmInfo.currStartMeridiem = selectedStartMeridiem
        } else {
            currAlarmInfo.currEndHour = selectedEndHour
            currAlarmInfo.currEndMinute = selectedEndMinute
            currAlarmInfo.currEndMeridiem = selectedEndMeridiem
        }
        do {
            try context.save()
            
            // If success, close view
//            presentation.wrappedValue.dismiss()
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
//    func selectTime() {
//        let time = AlarmInfo(context: context)
//
//        time.startHour = Int32(selectedStartHour)
//        time.startMinute = Int32(selectedStartMinute)
//        time.startMeridiem = selectedStartMeridiem
//
//        time.endHour = Int32(selectedEndHour)
//        time.endMinute = Int32(selectedEndMinute)
//        time.endMeridiem = selectedEndMeridiem
//
//        time.dateAdded = Date()
//
//        print(time)
//
//        // Saving
//        do {
//            try context.save()
//
//            // If success, close view
////            presentation.wrappedValue.dismiss()
//
//        } catch let err {
//            print(err.localizedDescription)
//        }
//    }
}

struct OrangeButton<Content: View>: View {
    var content: () -> Content
    var action: () -> Void
    
    init(@ViewBuilder content: @escaping () -> Content, action: @escaping () -> Void) {
        self.content = content
        self.action = action
    }
    var body: some View {
        HStack {
            Spacer()
            NavigationLink(destination: self.content()){
//                self.content()
                Image(systemName: "arrow.right")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.orange)
                    .clipShape(Circle())
//                    .onTapGesture {
//                        self.action();
//                    }
            }.simultaneousGesture(TapGesture().onEnded{
                self.action();
            })
        }.buttonStyle(PlainButtonStyle())
    }
}

struct GreenButton<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        HStack {
            Spacer()
            NavigationLink {
                content()
            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.black)
                    .background(Color.green)
                    .clipShape(Circle())
            }.buttonStyle(PlainButtonStyle())
        }
    }
}
