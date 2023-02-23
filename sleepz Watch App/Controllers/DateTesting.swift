//
//  DateTesting.swift
//  sleepz Watch App
//
//  Created by Erin Ly on 2023-02-22.
//

import SwiftUI
import Foundation

struct DateTesting: View {
    var body: some View {
        Text("hi")
//        Text(Date.now, format: .dateTime.day().month().year())
    }
    
    func getDate() {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        let currDate = Calendar.current.date(from: components) ?? Date.now
    }
    
}

//struct DateTesting_Previews: PreviewProvider {
//    static var previews: some View {
//        DateTesting()
//    }
//}
