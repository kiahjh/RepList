import SwiftUI

class SignupModel: ObservableObject {
  @Published var email = ""
  @Published var username = ""
  @Published var password = ""
  @Published var errorMessage: String? = nil
  @Published var isLoading = false

  func signup() async {
    print("Signing up...")

    guard self.isValidForm else { return }

    self.isLoading = true
    do {
      let response = try await api.signup(
        email: self.email,
        username: self.username,
        password: self.password
      )

      switch response {
      case .success(let res):
        keychain.set(res.data, forKey: "session_token")
      // TODO: update app state
      case .failure(let res):
        self.errorMessage = res.message
      }
    } catch {
      self.errorMessage = error.localizedDescription
    }
    self.isLoading = false
  }

  var isValidForm: Bool {
    self.email.isValidEmail() && self.username.isValidUsername() && self.password
      .isValidPassword()
  }
}
