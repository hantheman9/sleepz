//
//  ReusableComponents.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/2/23.
//

import SwiftUI
import CoreData
import UIKit

struct TimePickerView: View {
    @State private var selectedStartHour = ""
    @State private var selectedStartMinute = "00"
    @State private var selectedStartMeridiem = "am"
    
    private var hour = ["1","2","3"]
    private var minute = ["1","2","3"]
    private var meridiem = ["am","pm"]


    // Getting context from environment
    @Environment(\.managedObjectContext) var context
    
    // Presentation
    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack {
            HStack {
                Picker(selection: $selectedStartHour, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(hour, id: \.self) { startHour in
                        Text(startHour)
                        .onTapGesture {
                            selectedStartHour = startHour
                        }
                    }
                }
                Picker(selection: $selectedStartMinute, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(minute, id: \.self) { startMinute in
                        Text(startMinute)
                        .onTapGesture {
                            selectedStartMinute = startMinute
                        }
                    }
                }
                Picker(selection: $selectedStartMeridiem, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                    ForEach(meridiem, id: \.self) { startMeridiem in
                        Text(startMeridiem)
                        .onTapGesture {
                            selectedStartMeridiem = startMeridiem
                        }
                    }
                }
            }
            Button(action: selectTime, label: {
                Text("Save")
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
            })
            .buttonStyle(PlainButtonStyle())
            .disabled(selectedStartHour == "" )
        }
    }
    
    func selectTime() {
        let time = AlarmInfo(context: context)
        
        time.hour = selectedStartHour
        time.minute = selectedStartMinute
        time.meridiem = selectedStartMeridiem
        time.dateAdded = Date()
        
        // Saving
        do {
            try context.save()
            
            // If success, close view
            presentation.wrappedValue.dismiss()
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
}

struct OrangeButton<Content: View>: View {
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
                Image(systemName: "arrow.right")
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.orange)
                    .clipShape(Circle())
            }.buttonStyle(PlainButtonStyle())
            
        }
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
