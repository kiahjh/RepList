import SwiftUI

struct UnauthedScreen: View {
  @Environment(\.colorScheme) var cs
  @EnvironmentObject var appState: AppState

  var body: some View {
    ZStack {
      Rectangle()
        .fill(LinearGradient(
          gradient: Gradient(colors: [
            Color(self.cs, light: .white, dark: .black),
            Color(self.cs, light: .b150, dark: .b900),
          ]),
          startPoint: .top,
          endPoint: .bottom
        ))
        .ignoresSafeArea()
        .overlay(
          Image("light-swirl")
            .opacity(0.5)
        )

      VStack {
        Image("logo")
          .resizable()
          .scaledToFit()
          .frame(height: 150)
          .rotationEffect(Angle(degrees: -10))
        Spacer()
        VStack(spacing: 12) {
          BigButton(label: "Create an account", color: .primary) {
            self.appState.signingIn = true
          }
          .sheet(isPresented: self.$appState.signingIn) {
            SignupForm()
          }
          BigButton(label: "Log in", color: .secondary) {
            self.appState.loggingIn = true
          }
          .sheet(isPresented: self.$appState.loggingIn) {
            LoginForm()
          }
        }
      }
      .padding(.bottom, 20)
      .padding(.leading, 20)
      .padding(.trailing, 20)
      .padding(.top, 80)
    }
  }
}

#Preview("Initial screen") {
  UnauthedScreen()
    .environmentObject(AppState())
}

#Preview("Signing up") {
  UnauthedScreen()
    .environmentObject(AppState(signingUp: true))
}

#Preview("Logging in") {
  UnauthedScreen()
    .environmentObject(AppState(loggingIn: true))
}
