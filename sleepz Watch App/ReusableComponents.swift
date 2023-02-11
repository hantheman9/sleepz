//
//  ReusableComponents.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/2/23.
//

import SwiftUI
import CoreData
import WatchKit

struct TimePickerView<Content: View>: View {
    @State private var selectedStartHour = 1
    @State private var selectedStartMinute = 0
    @State private var selectedStartMeridiem = ""
    
    var nextContent: () -> Content
    
    private var hour = 1...12
    private var minute = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    private var meridiem = ["am","pm"]
    
    init(@ViewBuilder nextContent: @escaping () -> Content) {
        self.nextContent = nextContent
    }


    // Getting context from environment
    @Environment(\.managedObjectContext) var context
    
    // Presentation
    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selectedStartHour, label: Text("Hour")) {
                    ForEach(hour, id: \.self) { startHour in
                        Text(String(startHour))
                        .onTapGesture {
                            selectedStartHour = startHour
                        }
                    }
                }
                
                Picker(selection: $selectedStartMinute, label: Text("Minute")) {
                    ForEach(minute, id: \.self) { startMinute in
                        Text(startMinute >= 10 ? String(startMinute) : "0" + String(startMinute))
                        .onTapGesture {
                            selectedStartMinute = startMinute
                        }
                    }
                }
                
                Picker(selection: $selectedStartMeridiem, label: Text("Meridiem")) {
                    ForEach(meridiem, id: \.self) { startMeridiem in
                        Text(startMeridiem)
                        .onTapGesture {
                            selectedStartMeridiem = startMeridiem
                        }
                    }
                }
            }
            OrangeButton(content: {self.nextContent()}, action: {self.selectTime()})
//            Button(action: selectTime, label: {
//                Text("Save")
//                    .padding()
//            })
//            .disabled(selectedStartHour == 0)
        }
    }
    
    func selectTime() {
        let time = AlarmInfo(context: context)
        
        time.hour = String(selectedStartHour)
        time.minute = String(selectedStartMinute)
        time.meridiem = selectedStartMeridiem
        time.dateAdded = Date()
        
        // Saving
        do {
            try context.save()
            
            // If success, close view
//            presentation.wrappedValue.dismiss()
            
        } catch let err {
            print(err.localizedDescription)
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
