import SwiftUI

struct LoginScreen: View {
  @State var username: String = ""
  @State var password: String = ""
  @State var loginState: LoginState = .idle

  var message: String {
    switch self.loginState {
    case .idle:
      "Please enter your credentials"
    case .loading:
      "Loading..."
    case .success:
      "Success"
    case .invalid:
      "Invalid credentials"
    case .error(let message):
      message
    }
  }

  var body: some View {
    VStack {
      Text("Login")
        .font(.title)
        .padding(.bottom, 20)

      TextField("Username", text: self.$username)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .disableAutocorrection(true)
        .autocapitalization(.none)
      SecureField("Password", text: self.$password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .disableAutocorrection(true)
        .autocapitalization(.none)

      Button {
        self.loginState = .loading
        if self.username == "test" && self.password == "123" {
          self.loginState = .success
        } else {
          self.loginState = .error("Some error")
        }
      } label: {
        Text("Login")
      }
      .padding(.top, 20)
      .padding(.bottom, 40)

      Text(self.message)
    }
    .padding(40)
  }

  enum LoginState: Equatable {
    case idle
    case loading
    case success
    case invalid
    case error(String)
  }
}

#Preview {
  LoginScreen()
}
