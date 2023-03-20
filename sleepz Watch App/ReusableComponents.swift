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
    
    @Binding var currAlarmInfo : CurrentAlarmInfo
//    @Binding var existingAlarmInfo : AlarmInfo

//    var nextContent: () -> Content
    var isStart: Bool = true
        
    var hour = 1...12
    var minute = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    var meridiem = ["am","pm"]


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
                }.accessibilityIdentifier("hourPicker")
                
                Picker(selection: (self.isStart == true) ? $currAlarmInfo.currStartMinute : $currAlarmInfo.currEndMinute, label: Text("Minute")) {
                    ForEach(minute, id: \.self) { minuteOption in
                        Text(minuteOption >= 10 ? String(minuteOption) : "0" + String(minuteOption))
                    }
                }.accessibilityIdentifier("minutePicker")
                
                Picker(selection: (self.isStart == true) ? $currAlarmInfo.currStartMeridiem : $currAlarmInfo.currEndMeridiem, label: Text("Meridiem")) {
                    ForEach(meridiem, id: \.self) { meridiemOption in
                        Text(meridiemOption)
                    }
                }.accessibilityIdentifier("meridiemPicker")
            }
        }
    }
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
