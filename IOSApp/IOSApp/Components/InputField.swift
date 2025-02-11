import SwiftUI

struct InputField: View {
  @Environment(\.colorScheme) var cs

  @Binding var text: String
  var label: String
  var placeholder: String
  var isValid: Bool
  var type: UITextContentType
  var instructions: String

  init(
    text: Binding<String>,
    label: String,
    type: UITextContentType,
    placeholder: String = "",
    instructions: String,
    isValid: Bool = true
  ) {
    self._text = text
    self.label = label
    self.type = type
    self.placeholder = placeholder
    self.instructions = instructions
    self.isValid = isValid
  }

  @FocusState private var isFocused: Bool
  @State private var hasBeenEdited = false

  private var showInvalidWarning: Bool {
    !self.isValid && self.hasBeenEdited
 }

  var body: some View {
    VStack(alignment: .leading) {
      Text(self.label)
        .foregroundColor(
          self.showInvalidWarning
            ? Color(
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
      .background(Color(self.cs, light: .white.opacity(0.7), dark: .black.opacity(0.5)))
      .cornerRadius(10)
      .overlay {
        RoundedRectangle(cornerRadius: 10)
          .stroke(
            self.showInvalidWarning
              ? Color(
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
          .foregroundColor(
            Color(
              self.cs,
              light: Color(hex: "bb0000")!,
              dark: Color(hex: "ee0000")!
            )
          )
          .scaleEffect(self.showInvalidWarning ? 1 : 0)
          .opacity(self.showInvalidWarning ? 1 : 0)
      }
    }
  }
}
