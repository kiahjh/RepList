import SwiftUI

struct BigButton: View {
  @Environment(\.colorScheme) var cs

  var label: String
  var color: ColorType
  var disabled: Bool = false
  var action: () -> Void

  init(_ label: String, color: ColorType, disabled: Bool = false, action: @escaping () -> Void) {
    self.label = label
    self.color = color
    self.disabled = disabled
    self.action = action
  }

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
        self.color == .primary
          ? Color(self.cs, light: .b50, dark: .b50) : Color(self.cs, light: .b500, dark: .b500)
      )
      .background(
        self.color == .primary
          ? Color(self.cs, light: .b500, dark: .b600) : Color(self.cs, light: .b200, dark: .b850)
      )
      .cornerRadius(16)
    }
    .disabled(self.disabled)
    .opacity(self.disabled ? 0.4 : 1)
  }

  enum ColorType {
    case primary
    case secondary
  }
}

#Preview {
  VStack(spacing: 12) {
    BigButton("Get started", color: .primary) {}
    BigButton("Get started", color: .primary, disabled: true) {}
      .padding(.bottom, 40)
    BigButton("Log in", color: .secondary) {}
    BigButton("Log in", color: .secondary, disabled: true) {}
  }.padding()
}
