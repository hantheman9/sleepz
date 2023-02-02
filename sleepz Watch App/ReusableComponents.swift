//
//  ReusableComponents.swift
//  sleepz Watch App
//
//  Created by Ainley on 2/2/23.
//

import SwiftUI

struct TimePickerView: View {
    @State private var selectedStartHour = "1"
    @State private var selectedStartMinute = "1"
    @State private var selectedStartMeridiem = "am"

    var body: some View {
        HStack {
            Picker(selection: $selectedStartHour, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
            }
            Picker(selection: $selectedStartMinute, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
            }
            Picker(selection: $selectedStartMeridiem, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                Text("am").tag(1)
                Text("pm").tag(2)
            }
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
