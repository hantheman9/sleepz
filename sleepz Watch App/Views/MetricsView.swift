//
//  MetricsView.swift
//  sleepz Watch App
//
//  Created by Burhan Drak Sibai on 1/31/23.
//

import SwiftUI

struct MetricsView: View {
    var body: some View {
        VStack(alignment: .leading) {
           ElapsedTimeView(
            elapsedTime: 3 * 60 + 16.99,
            showSubseconds: true
           ).foregroundColor(Color.yellow)
            Text(
                145.formatted(
                    .number.precision(.fractionLength(0))
                )
                + " bpm"
            )
        }
        .font(.system(.title, design: .rounded)
            .monospacedDigit()
            .lowercaseSmallCaps()
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
