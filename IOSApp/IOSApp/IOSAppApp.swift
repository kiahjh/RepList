import SwiftUI

@main
struct IOSAppApp: App {
  @StateObject var appState = AppState()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(self.appState)
    }
  }
}
