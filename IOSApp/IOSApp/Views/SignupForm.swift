import SwiftUI

struct SignupForm: View {
  @Environment(\.colorScheme) var cs
  @StateObject private var viewModel = SignupModel()

  var buttonText: String {
    self.viewModel.isLoading ? "Loading..." : "Sign up"
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
            text: self.$viewModel.email,
            label: "Email",
            placeholder: "johndoe@example.com",
            isValid: self.viewModel.email.isValidEmail(),
            type: .emailAddress,
            instructions: "Please enter a valid email address"
          )
          InputField(
            text: self.$viewModel.username,
            label: "Username",
            placeholder: "john95",
            isValid: self.viewModel.username.isValidUsername(),
            type: .username,
            instructions: "Must contain at least 3 characters, only letters, numbers, and underscores"
          )
          InputField(
            text: self.$viewModel.password,
            label: "Password",
            placeholder: "••••••••••••",
            isValid: self.viewModel.password.isValidPassword(),
            type: .password,
            instructions: "Must contain at least 8 characters"
          )
        }

        BigButton(
          label: self.buttonText,
          color: .primary,
          disabled: !self.viewModel.isValidForm || self.viewModel.isLoading
        ) {
          Task {
            await self.viewModel.signup()
          }
        }

        if let errorMessage = self.viewModel.errorMessage {
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

#Preview("Signing up") {
  SignupForm()
    .environmentObject(AppState())
}
