import SwiftUI

struct Profile: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      Text("profile/settings")
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
