import SwiftUI

struct BigButton: View {
  @Environment(\.colorScheme) var cs

  var label: String
  var color: ColorType
  var disabled: Bool = false
  var action: () -> Void

  var body: some View {
    Button(action: self.action) {
      HStack {
        Spacer()
        Text(self.label)
        Spacer()
      }
      .padding(16)
      .font(.system(size: 20, weight: .bold))
      .foregroundStyle(
        self.color == .primary ?
          Color(self.cs, light: .b50, dark: .b50) :
          Color(self.cs, light: .b500, dark: .b500)
      )
      .background(
        self.color == .primary ?
          Color(self.cs, light: .b500, dark: .b600) :
          Color(self.cs, light: .b200, dark: .b850)
      )
      .cornerRadius(16)
    }
    .disabled(self.disabled)
    .opacity(self.disabled ? 0.5 : 1)
  }

  enum ColorType {
    case primary
    case secondary
  }
}

#Preview {
  VStack(spacing: 12) {
    BigButton(label: "Get started", color: .primary) {}
    BigButton(label: "Get started", color: .primary, disabled: true) {}
      .padding(.bottom, 40)
    BigButton(label: "Log in", color: .secondary) {}
    BigButton(label: "Log in", color: .secondary, disabled: true) {}
  }.padding()
}
