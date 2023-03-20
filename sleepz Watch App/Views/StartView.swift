//
//  ContentView.swift
//  sleepz Watch App
//
//  Created by Burhan Drak Sibai on 1/31/23.
//

import SwiftUI
import HealthKit

struct StartView: View {
    var body: some View {
        
        HStack{
            VStack{
                Button {
                } label: {
                    Image(systemName: "checkmark.circle")
                }
                .tint(Color.green)
                .font(.title2)
                NavigationLink(
                    destination: SessionPagingView()
                ) {
                    Text("Start")
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

