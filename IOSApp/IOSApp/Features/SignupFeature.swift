import ComposableArchitecture
import SwiftUI

@Reducer
struct Signup {
  @Dependency(\.apiClient) var apiClient

  @ObservableState
  struct State: Equatable {
    @Shared(.sessionToken) var sessionToken

    var email: String = ""
    var username: String = ""
    var password: String = ""
    var errorMessage: String? = nil

    var buttonEnabled: Bool {
      self.email.isValidEmail()
        && self.username.isValidUsername()
        && self.password.isValidPassword()
    }
  }

  enum Action: BindableAction {
    case binding(BindingAction<State>)
    case loginButtonTapped
    case setErrorMessage(String)
    case setSessionToken(String)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .loginButtonTapped:
        return .run { [state] send in
          do {
            let res = try await apiClient.signup(
              email: state.email,
              username: state.username,
              password: state.password
            )
            switch res {
            case .success(let value):
              await send(.setSessionToken(value.data))
            case .failure(let error):
              await send(.setErrorMessage(error.message))
            }
          } catch {
            await send(.setErrorMessage(error.localizedDescription))
          }
        }
      case .setErrorMessage(let message):
        state.errorMessage = message
        return .none
      case .setSessionToken(let token):
        state.$sessionToken.withLock { $0 = token }
        return .none
      }
    }
  }
}

struct SignupView: View {
  @Bindable var store: StoreOf<Signup>

  var body: some View {
    VStack {
      VStack(spacing: 20) {
        InputField.init(
          text: self.$store.email,
          label: "Email",
          type: .emailAddress,
          placeholder: "johndoe@example.com",
          instructions: "Please provide a valid email address",
          isValid: self.store.email.isValidEmail()
        )
        InputField.init(
          text: self.$store.username,
          label: "Username",
          type: .username,
          placeholder: "john_doe98",
          instructions: "Username must be at least 3 characters long",
          isValid: self.store.username.isValidUsername()
        )
        InputField.init(
          text: self.$store.password,
          label: "Password",
          type: .password,
          placeholder: "••••••••",
          instructions: "Password must be at least 8 characters long",
          isValid: self.store.password.isValidPassword()
        )

        if let error = self.store.errorMessage {
          Text(error)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
        }
      }
      Spacer()
      BigButton("Log in", color: .primary, disabled: !store.buttonEnabled) {
        self.store.send(.loginButtonTapped)
      }
    }
    .padding(.top, 30)
    .padding(30)
    .background(Gradient(colors: [.clear, .b200]))
  }
}

#Preview("Empty") {
  SignupView(
    store: Store(initialState: Signup.State()) {
      Signup()
    })
}

#Preview("Filled in with error") {
  SignupView(
    store: Store(
      initialState: Signup.State(
        email: "foo@bar.com",
        username: "foo_87",
        password: "password",
        errorMessage: "Looks like there was an error"
      )
    ) {
      Signup()
    })
}
