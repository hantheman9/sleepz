

import SwiftUI

struct CurrentAccView: View {
    var value: String
    var units = "m/s²"
    
    @State var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            Text(String(value))
                .fontWeight(.medium)
                .font(.system(size: 20))
            VStack {
                Text("m/s²")
            }
//                    .font(.footnote)
////                Image(systemName: "suit.heart.fill")
////                    .resizable()
////                    .font(Font.system(.largeTitle).bold())
////                    .frame(width: 16, height: 16)
////                    .scaleEffect(self.isAnimating ? 1 : 0.8)
////                    .animation(Animation.linear(duration: 0.5).repeatForever())
//            }
        }
//        .onAppear {
//            self.isAnimating = true
//        }
    }
}

