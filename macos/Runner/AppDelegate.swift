import Cocoa
import FlutterMacOS

// @NSApplicationMain
// class AppDelegate: FlutterAppDelegate {
//   override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//      return true
//   }
// }

@main
class AppDelegate: FlutterAppDelegate {

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
         return true

        // Listen for macOS Sleep and Wake Events
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onMacSleep),
            name: NSWorkspace.willSleepNotification, object: nil)

        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onMacWake),
            name: NSWorkspace.didWakeNotification, object: nil)
    }

    @objc func onMacSleep() {
        print("Mac is going to sleep.")
        // Send event to Flutter
        let channel = FlutterMethodChannel(name: "app_lifecycle", binaryMessenger: self.mainFlutterWindow!.contentViewController as! FlutterBinaryMessenger)
        channel.invokeMethod("onSleep", arguments: nil)
    }

    @objc func onMacWake() {
        print("Mac has woken up.")
        // Send event to Flutter
        let channel = FlutterMethodChannel(name: "app_lifecycle", binaryMessenger: self.mainFlutterWindow!.contentViewController as! FlutterBinaryMessenger)
        channel.invokeMethod("onWake", arguments: nil)
    }
}