import SwiftUI

struct ContentView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    if self.appState.sessionToken != nil {
      Main()
    } else {
      UnauthedScreen()
    }
  }
}

#Preview {
  ContentView()
    .environmentObject(AppState())
}
