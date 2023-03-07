import WatchKit
import Foundation

// Haptics cannot run while the app is asleep or turned off. So we need to start a session to activate the alarm and persist even when the watch is off or the app is not running

class ExtensionDelegate: NSObject, ObservableObject, WKExtensionDelegate, WKExtendedRuntimeSessionDelegate {
    
    private var session: WKExtendedRuntimeSession!
    
    func setupSession() {
        session = WKExtendedRuntimeSession()
        session.delegate = self
        print("Session SetUp")
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("Session Ended")
        return
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Session Started")
        session.notifyUser(hapticType: WKHapticType.notification, repeatHandler: {_ in TimeInterval(1.0)})
        return
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Session Expired")
        return
    }
    
    func scheduleAlarm() {
        // This is just proof of concept code that triggers the alarm 2 seconds after pressing "Start Alarm". This would be replaced with the actual real-time alarm that our algorithm decides on
        session.start(at: Date() + TimeInterval(2))
    }
    
    func stopSession() {
        session.invalidate()
    }
}
