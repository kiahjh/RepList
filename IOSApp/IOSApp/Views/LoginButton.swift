import SwiftUI

struct LoginButton: View {
  var provider: Provider

  var body: some View {
    Button {} label: {
      HStack {
        Spacer()
        Image(self.provider == .google ? "google-logo" : "apple-logo")
          .resizable()
          .frame(width: 28, height: 28)
        Spacer()
      }
      .padding(.vertical, 14)
      .background(Gradient(colors: self.provider == .google ? [
        .white,
        primary50
      ] : [
        neutral800,
        .black,
      ]))
      .cornerRadius(16)
      .shadow(color: .black.opacity(0.09), radius: 6, x: 0, y: 3)
    }
  }
}

#Preview {
  LoginButton(provider: .google)
  LoginButton(provider: .apple)
}

enum Provider {
  case google
  case apple
}
