//
//  ControlsView.swift
//  sleepz Watch App
//
//  Created by Burhan Drak Sibai on 1/31/23.
//

import SwiftUI

struct ControlsView: View {
    var body: some View {
        HStack{
            VStack{
                Button {
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(Color.red)
                .font(.title2)
                Text("End")
            }
        }
    }
    
    struct ControlsView_Previews: PreviewProvider {
        static var previews: some View {
            ControlsView()
        }
    }}
