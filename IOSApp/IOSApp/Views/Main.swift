import SwiftUI

struct Main: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      Text("Look mom an app")
        .padding()
      Button {
        self.appState.sessionToken = nil
        keychain.delete("session_token")
      } label: {
        Text("Log out")
      }
    }
  }
}

#Preview {
  Main()
}
