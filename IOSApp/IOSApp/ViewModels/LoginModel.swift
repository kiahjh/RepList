import SwiftUI

class LoginModel: ObservableObject {
  @Published var username = ""
  @Published var password = ""
  @Published var errorMessage: String? = nil
  @Published var isLoading = false

  func login() async {
    guard self.isValidForm else { return }

    self.isLoading = true
    do {
      let response = try await api.login(
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
    self.username.isValidUsername() && self.password
      .isValidPassword()
  }
}
