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
    
//    @StateObject var currAlarmInfo = CurrentAlarmInfo()
    let coreDM: PersistentController
    
//    @FetchRequest (
//        entity: AlarmInfo.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmInfo.dateAdded, ascending: false)]
//    )
//
    var results: [AlarmInfo]
    
    init(coreDM: PersistentController) {
        self.coreDM = coreDM
        self.results = self.coreDM.getAllAlarms()
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(results) { item in
                    
                    let alarmDetails = dateFormatter(dataObject: item)

                    HStack {
                        NavigationLink(
                            destination: {},
                            label: {
                                Text(alarmDetails.startTime + " - " + alarmDetails.endTime)
                            }
                        )
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
    }
//    func currState(dataObject: AlarmInfo) -> [(Int,Int,String)] {
//
//        let startHourTime = Int(dataObject.startHour)
//        let startMinuteTime = Int(dataObject.startMinute)
//        let startMeridiemTime = dataObject.startMeridiem!
//
//        let endHourTime = Int(dataObject.endHour)
//        let endMinuteTime = Int(dataObject.endMinute)
//        let endMeridiemTime = dataObject.endMeridiem!
//
//
//        return [(startHourTime, startMinuteTime, startMeridiemTime), (endHourTime, endMinuteTime, endMeridiemTime)]
//    }
    
    func dateFormatter(dataObject: AlarmInfo) -> (startTime: String, endTime: String) {
        
        let startHourTime = "\(dataObject.startHour)"
        let startMinuteTime = dataObject.startMinute >= 10 ? "\(dataObject.startMinute)" : "0" + "\(dataObject.startMinute)"

        let endHourTime = "\(dataObject.endHour)"
        let endMinuteTime = dataObject.endMinute >= 10 ? "\(dataObject.endMinute)" : "0" + "\(dataObject.endMinute)"
        
        
        return (startHourTime + ":" + startMinuteTime, endHourTime + ":" + endMinuteTime)
    }
}

final class CurrentAlarmInfo: ObservableObject {
    @Published var currStartHour: Int = 0
    @Published var currStartMinute: Int = 0
    @Published var currStartMeridiem: String = ""

    @Published var currEndHour: Int = 0
    @Published var currEndMinute: Int = 0
    @Published var currEndMeridiem: String = ""
}

//struct AlarmEditView: View {
//
//    let alarm: AlarmInfo
//    @State var currAlarmInfo: AlarmInfo
//
//    var body: some View {
//        VStack {
//
//        }
//        Text("Set schedule")
//        GreenButton(content: {AlarmHome(coreDM: PersistentController())})
//    }
//}

struct AlarmStartTimeView: View {
    @State var currAlarmInfo = CurrentAlarmInfo()
    
    var body: some View {
        VStack{
            Text("Set wake up window end")
            TimePickerView(currAlarmInfo: $currAlarmInfo, isStart: true)
            OrangeButton(content: {AlarmEndTimeView(currAlarmInfo: $currAlarmInfo)}, action: {})
        }
//        OrangeButton(content: {AlarmEndTimeView()})
    }
}

struct AlarmEndTimeView: View {
    @Binding var currAlarmInfo: CurrentAlarmInfo

    var body: some View {
        Text("Set wake up window end")
        TimePickerView(currAlarmInfo: $currAlarmInfo, isStart: false)
//        OrangeButton(content: {AlarmEndTimeView()})
    }
}

//struct AlarmDayView: View {
//    var body: some View {
//        Text("Set schedule")
//        GreenButton(content: {AlarmHome(coreDM: PersistentController())})
//    }
//}

struct AlarmHome_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHome(coreDM: PersistentController())
    }
}



// OLD BELOW

//struct AlarmEndTimeView: View {
//    @StateObject var currAlarmInfo = CurrentAlarmInfo()
//
//
//    var body: some View {
//        Text("Set wake up window end")
//        TimePickerView(nextContent: {AlarmHome(coreDM: PersistentController())}, isStart: false)
////        OrangeButton(content: {AlarmEndTimeView()})
//    }
//}

//struct SetAlarmView: View {
//    @Environment(\.presentationMode) var presentation
//    @Environment(\.managedObjectContext) var context
//
//    // Saved navigating from one picker to another
//    @State var currentQuestionIndex = 0
//
//    // Saved picker details
//    @State var answers = Array(repeating:(selectedHour: 0, selectedMinute: 0, selectedMeridiem: ""), count: questions.count)
//    @StateObject var currAlarmInfo = CurrentAlarmInfo()
//
//    private var hour = 1...12
//    private var minute = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
//    private var meridiem = ["am","pm"]
//
//    // Create alarm object, pass it into time picker
//
//    init(currAnswer: [(Int,Int,String)]? = nil) {
//        if currAnswer != nil {
//            answers = currAnswer!
//        }
//    }
//
//    var body: some View {
//        VStack {
//            Text(questions[currentQuestionIndex].text)
//            HStack {
//                Picker(selection: $currAlarmInfo.currStartHour, label: Text("Hour")) {
//                    ForEach(hour, id: \.self) { hourOption in
//                        Text(String(hourOption))
//                    }
//                }
//
//                Picker(selection: $currAlarmInfo.currStartMinute, label: Text("Minute")) {
//                    ForEach(minute, id: \.self) { minuteOption in
//                        Text(minuteOption >= 10 ? String(minuteOption) : "0" + String(minuteOption))
//                    }
//                }
//
//                Picker(selection: $currAlarmInfo.currStartMeridiem, label: Text("Meridiem")) {
//                    ForEach(meridiem, id: \.self) { startMeridiem in
//                        Text(startMeridiem)
//                    }
//                }
//            }
//            Button(action: nextButtonTapped) {
//                Text("Next")
//            }
//        }
//        .navigationTitle("Step \(currentQuestionIndex + 1)")
////            OrangeButton(content: {AlarmEndTimeView()})
//    }
//    private func nextButtonTapped() {
//        if currentQuestionIndex == questions.count - 1 {
//            // Submit form and go back to home screen
//            submitForm()
//
//        } else {
//            // Move to next question
//            currentQuestionIndex += 1
//        }
//    }
//
//    private func submitForm() {
//        let time = AlarmInfo(context: context)
//
////        coreDM.saveMovie(currAlarm: currAlarmInfo)
//
//        // Saving answers to Core Data (AlarmInfo)
//        time.startHour = Int32(answers[0].selectedHour)
//        time.startMinute = Int32(answers[0].selectedMinute)
//        time.startMeridiem = answers[0].selectedMeridiem
//
//        time.endHour = Int32(answers[1].selectedHour)
//        time.endMinute = Int32(answers[1].selectedMinute)
//        time.endMeridiem = answers[1].selectedMeridiem
//
//        // Then dismiss the form view and return to home screen
//        dismissFormView()
//    }
//
//    private func dismissFormView() {
//
//        currentQuestionIndex = 0
//        @State var answers = Array(repeating:(selectedHour: 0, selectedMinute: 0, selectedEndMeridiem: ""), count: questions.count)
//
//        // Using `presentationMode` to dismiss the form view
//        presentation.wrappedValue.dismiss()
//    }
//}
//
//let questions = [Question(text: "Set wake up window start"), Question(text: "Set wake up window end")]
//
//struct Question {
//    let text: String
//}
