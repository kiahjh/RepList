import SwiftUI

class AppState: ObservableObject {
  @Published var sessionToken: String? = nil
  @Published var loggingIn = false
  @Published var signingIn = false

  init(loggingIn: Bool = false, signingUp: Bool = false) {
    self.loggingIn = loggingIn
    self.signingIn = signingUp
    self.sessionToken = keychain.get("session_token")
  }
}
