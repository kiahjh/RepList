// import Models
import SwiftUI

struct LoginScreen: View {
  @State var username = ""
  @State var password = ""

  var body: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()

        VStack {
          Form {
            VStack(alignment: .leading) {
              Text("Username").font(.subheadline)
              TextField("johndoe", text: self.$username)
                .font(.system(size: 20))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(gray100)
                .cornerRadius(8)
            }.padding(.bottom)

            VStack(alignment: .leading) {
              Text("Password").font(.subheadline)
              TextField("••••••••", text: self.$password)
                .font(.system(size: 20))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(gray100)
                .cornerRadius(8)
            }.padding(.bottom)

            Spacer()

            HStack {
              Spacer()
              Button {}
                label: {
                  Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
          }
          .formStyle(.columns)
        }
        .frame(width: 280, height: 200)
        .padding(28)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color(red: 0.85, green: 0.85, blue: 0.9), radius: 8, x: 0, y: 10)

        Spacer()
      }
      Spacer()
    }.background(Color(red: 0.9, green: 0.9, blue: 0.95))
  }
}

#Preview {
  LoginScreen()
}

extension URL {
  static var root: URL {
    URL(string: "http://127.0.0.1:8080")!
  }

  static func api(_ path: String) -> URL {
    self.root.appendingPathComponent(path)
  }
}

// Form {
//   HStack {
//     Text("Username")
//     TextField("johndoe", text: self.$username)
//       .textInputAutocapitalization(.never)
//       .multilineTextAlignment(.trailing)
//   }
//   HStack {
//     Text("Password")
//     TextField("••••••••••", text: self.$password)
//       .textInputAutocapitalization(.never)
//       .multilineTextAlignment(.trailing)
//   }
//   Button {
//     Task {
//       var request = URLRequest(url: .api("/login"))
//       request.httpMethod = "POST"
//       request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//       struct Input: Encodable {
//         let username: String
//         let password: String
//       }
//
//       let input = Input(username: self.username, password: self.password)
//       let encoder = JSONEncoder()
//       request.httpBody = try! encoder.encode(input)
//
//       do {
//         let (data, res) = try await URLSession.shared.data(for: request)
//         let decoder = JSONDecoder()
//         print("?")
//         let user = try decoder.decode(User.self, from: data)
//         self.username = user.name
//         self.password = user.id.uuidString
//         print(user)
//       } catch {
//         print(error, "TODO: Handle error")
//       }
//     }
//   } label: {
//     Text("Login")
//   }.disabled(self.username.isEmpty || self.password.isEmpty)
// }
