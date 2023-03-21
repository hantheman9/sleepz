
import SwiftUI
import HealthKit
import Combine



struct StartSession: View {
    @State var alarmStartTime: Date
    var body: some View {
        HeartRateMesurementView(alarmStartTime: alarmStartTime)
    }
}

var timer: AnyCancellable?
var endTime: Date?

struct HeartRateMesurementView: View {
    @State var alarmStartTime: Date
    @EnvironmentObject private var extensionDelegate: ExtensionDelegate

    @ObservedObject var heartRateMeasurementService = HeartRateMeasurementService()
    @ObservedObject var sensorLogger = accelerometerService()
    @ObservedObject var sleepStageServ = SleepStageService()
    

    private func playHapticFeedbackFor10Seconds() {
        let device = WKInterfaceDevice.current()
        endTime = Date().addingTimeInterval(10)
        
        timer = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if let endTime = endTime, Date() < endTime {
                    device.play(.notification) // Choose the type of haptic feedback you want to play
                } else {
                    timer?.cancel()
                    timer = nil
                    endTime = nil
                }
            }
    }
    
    private func scheduleFunctions() {
        let delay = alarmStartTime.timeIntervalSince(Date()) + 10 // Calculate the delay based on alarmStartTime
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            playHapticFeedbackFor10Seconds()
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                CurrentAccView(value: sensorLogger.collectiveAcc)
//                Spacer()
            }.padding()
            
            VStack {
                Spacer()
                CurrentHeartRateView(value: heartRateMeasurementService.currentHeartRate)
//                Spacer()
            }.padding()
            
            VStack {
                Spacer()
                Spacer()
                CurrentSleepStageView(value: sleepStageServ.sleepStage)
                Spacer()
            }
        }
        .onAppear(perform: {
            scheduleFunctions()
        })
    }
}

struct HeartRateMesurementView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateMesurementView(alarmStartTime: Date())
    }
}


