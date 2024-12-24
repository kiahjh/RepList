import Foundation

extension String {
  func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: self)
  }

  func isValidUsername() -> Bool {
    let usernameRegEx = "^[a-zA-Z0-9_]{3,}$"
    let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
    return usernamePred.evaluate(with: self)
  }

  func isValidPassword() -> Bool {
    self.count >= 8
  }
}
