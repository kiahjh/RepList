import SwiftUI

struct SignupSheet: View {
  @Environment(\.colorScheme) var cs
  @EnvironmentObject var appState: AppState

  @State private var email = ""
  @State private var username = ""
  @State private var password = ""

  @State private var errorMessage: String? = nil

  @StateObject private var signupRequest = Request<Api.SignupOutput>()

  var buttonText: String {
    self.signupRequest.state == .loading ? "Loading..." : "Sign up"
  }

  var body: some View {
    ZStack {
      Rectangle()
        .fill(LinearGradient(
          gradient: Gradient(colors: [
            .clear, Color(self.cs, light: .b150, dark: .b900),
          ]),
          startPoint: .top,
          endPoint: .bottom
        ))
        .ignoresSafeArea()

      VStack(spacing: 40) {
        Text("Create an account")
          .font(.system(size: 24, weight: .semibold))

        VStack(spacing: 20) {
          InputField(
            text: self.$email,
            label: "Email",
            placeholder: "johndoe@example.com",
            isValid: self.email.isValidEmail(),
            type: .emailAddress,
            instructions: "Please enter a valid email address"
          )
          InputField(
            text: self.$username,
            label: "Username",
            placeholder: "john95",
            isValid: self.username.isValidUsername(),
            type: .username,
            instructions: "Must contain at least 3 characters, only letters, numbers, and underscores"
          )
          InputField(
            text: self.$password,
            label: "Password",
            placeholder: "••••••••••••",
            isValid: self.password.isValidPassword(),
            type: .password,
            instructions: "Must contain at least 8 characters"
          )
        }

        BigButton(
          label: self.buttonText,
          color: .primary,
          disabled: self.signupRequest.state == .loading || !self.email.isValidEmail() || !self
            .username.isValidUsername() || !self.password.isValidPassword()
        ) {
          self.signupRequest.fn = {
            try await api.signup(
              email: self.email,
              username: self.username,
              password: self.password
            )
          }
          Task {
            await self.signupRequest.fire()

            switch self.signupRequest.state {
            case .done(let response):
              switch response {
              case .success(status: _, data: let data): // happy path
                keychain.set(data.token, forKey: "session_token")
                self.appState.signingIn = false
                self.appState.sessionToken = data.token
              case .failure(status: _, code: _, message: let message):
                self.errorMessage = message
              }
            case .error(let error):
              self.errorMessage = error.localizedDescription
            default:
              break
            }
          }
        }

        if let errorMessage = self.errorMessage {
          Text(errorMessage)
            .multilineTextAlignment(.center)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color(
              self.cs,
              light: Color(hex: "bb0000")!,
              dark: Color(hex: "ee0000")!
            ))
        }
      }
      .padding(20)
    }
  }
}

struct LoginSheet: View {
  @Environment(\.colorScheme) var cs
  @EnvironmentObject var appState: AppState

  @State private var username = ""
  @State private var password = ""

  @State private var errorMessage: String? = nil

  @StateObject private var loginRequest = Request<Api.LoginOutput>()

  var buttonText: String {
    self.loginRequest.state == .loading ? "Loading..." : "Log in"
  }

  var body: some View {
    ZStack {
      Rectangle()
        .fill(LinearGradient(
          gradient: Gradient(colors: [
            .clear, Color(self.cs, light: .b150, dark: .b900),
          ]),
          startPoint: .top,
          endPoint: .bottom
        ))
        .ignoresSafeArea()

      VStack(spacing: 40) {
        Text("Log into your account")
          .font(.system(size: 24, weight: .semibold))

        VStack(spacing: 20) {
          InputField(
            text: self.$username,
            label: "Username",
            placeholder: "john95",
            isValid: self.username.isValidUsername(),
            type: .username,
            instructions: "Must contain at least 3 characters, only letters, numbers, and underscores"
          )
          InputField(
            text: self.$password,
            label: "Password",
            placeholder: "••••••••••••",
            isValid: self.password.isValidPassword(),
            type: .password,
            instructions: "Must contain at least 8 characters"
          )
        }

        BigButton(
          label: self.buttonText,
          color: .primary,
          disabled: self.loginRequest.state == .loading || !self
            .username.isValidUsername() || !self.password.isValidPassword()
        ) {
          self.loginRequest.fn = {
            try await api.login(
              username: self.username,
              password: self.password
            )
          }
          Task {
            await self.loginRequest.fire()

            switch self.loginRequest.state {
            case .done(let response):
              switch response {
              case .success(status: _, data: let data): // happy path
                keychain.set(data.token, forKey: "session_token")
                self.appState.loggingIn = false
                self.appState.sessionToken = data.token
              case .failure(status: _, code: _, message: let message):
                self.errorMessage = message
              }
            case .error(let error):
              self.errorMessage = error.localizedDescription
            default:
              break
            }
          }
        }

        if let errorMessage = self.errorMessage {
          Text(errorMessage)
            .multilineTextAlignment(.center)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color(
              self.cs,
              light: Color(hex: "bb0000")!,
              dark: Color(hex: "ee0000")!
            ))
        }
      }
      .padding(20)
    }
  }
}

struct InputField: View {
  @Environment(\.colorScheme) var cs

  @Binding var text: String
  var label: String
  var placeholder: String
  var isValid: Bool = true
  var type: UITextContentType
  var instructions: String

  @FocusState private var isFocused: Bool
  @State private var hasBeenEdited = false

  private var showInvalidWarning: Bool {
    !self.isValid && self.hasBeenEdited
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(self.label)
        .foregroundColor(
          self.showInvalidWarning ? Color(
            self.cs,
            light: Color(hex: "bb0000")!,
            dark: Color(hex: "ee0000")!
          ) : Color(self.cs, light: .b400, dark: .b500)
        )
        .padding(.leading, 8)
        .font(.system(size: 16, weight: .semibold))

      Group {
        if self.type == .password {
          SecureField(self.placeholder, text: self.$text)
        } else {
          TextField(self.placeholder, text: self.$text)
        }
      }
      .focused(self.$isFocused)
      .onChange(of: self.isFocused, initial: false) { _, newState in
        if newState == false {
          withAnimation {
            self.hasBeenEdited = true
          }
        }
      }
      .autocapitalization(.none)
      .disableAutocorrection(true)
      .textContentType(self.type)
      .font(.system(size: 20, weight: .medium))
      .padding(10)
      .background(Color(self.cs, light: .white.opacity(0.5), dark: .black.opacity(0.5)))
      .cornerRadius(8)
      .overlay {
        RoundedRectangle(cornerRadius: 8)
          .stroke(
            self.showInvalidWarning ? Color(
              self.cs,
              light: Color(hex: "dd0000")!,
              dark: Color(hex: "990000")!
            ) : .clear,
            lineWidth: 2
          )
      }

      if self.showInvalidWarning {
        Text(self.instructions)
          .font(.system(size: 12, weight: .medium))
          .padding(.leading, 8)
          .foregroundColor(Color(
            self.cs,
            light: Color(hex: "bb0000")!,
            dark: Color(hex: "ee0000")!
          ))
          .scaleEffect(self.showInvalidWarning ? 1 : 0)
          .opacity(self.showInvalidWarning ? 1 : 0)
      }
    }
  }
}

// #Preview("Signing up") {
//   SignupSheet()
// }

#Preview("Logging in") {
  LoginSheet()
}
