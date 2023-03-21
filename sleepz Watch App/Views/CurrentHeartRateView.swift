

import SwiftUI

struct CurrentHeartRateView: View {
    var value: Int
    var units = "BPM"
    
    @State var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            Text(String(value))
                .fontWeight(.medium)
                .font(.system(size: 20))
            VStack {
                Text("BPM")
                    .font(.footnote)
                Image(systemName: "suit.heart.fill")
                    .resizable()
                    .font(Font.system(.largeTitle).bold())
                    .frame(width: 8, height: 8)
                    .scaleEffect(self.isAnimating ? 1 : 0.8)
                    .animation(Animation.linear(duration: 0.5).repeatForever())
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}
