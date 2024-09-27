import SwiftUI

struct LoginScreen: View {
  @State var username = ""
  @State var password = ""

  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text("RepList").fontWeight(.semibold).font(.system(size: 64)).foregroundColor(primary200)
        Spacer()
      }
      Spacer()
      VStack(alignment: .center, spacing: 20) {
        Text("Log in with:").foregroundColor(.black).opacity(0.27)
          .font(.system(size: 16, weight: .semibold))
        LoginButton(provider: .google)
        LoginButton(provider: .apple)
      }.padding(.bottom, 40).padding(.horizontal, 40)
    }
    .padding(.top, 80)
    .background(Gradient(colors: [.white, primary200]))
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
