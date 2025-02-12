import ComposableArchitecture
import SwiftUI

@Reducer
struct Unauthed {
  @ObservableState
  struct State: Equatable {
    // FIX: should be an enum (https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/treebasednavigation#Enum-state)
    @Presents var signup: Signup.State?
    @Presents var login: Login.State?
  }

  enum Action {
    case login(PresentationAction<Login.Action>)
    case loginButtonTapped
    case signup(PresentationAction<Signup.Action>)
    case signupButtonTapped
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .login:
        return .none
      case .loginButtonTapped:
        state.login = Login.State()
        return .none
      case .signup:
        return .none
      case .signupButtonTapped:
        state.signup = Signup.State()
        return .none
      }
    }
    .ifLet(\.$signup, action: \.signup) {
      Signup()
    }
    .ifLet(\.$login, action: \.login) {
      Login()
    }
  }
}

struct UnauthedView: View {
  @Bindable var store: StoreOf<Unauthed>

  var body: some View {
    ZStack(alignment: .center) {
      Image("Swirl")
        .resizable()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .opacity(0.5)

      VStack {
        Image("Logo")
          .resizable()
          .frame(width: 110, height: 140)
          .rotationEffect(.degrees(-15))
        Spacer()
        VStack {
          BigButton("Log in", color: .primary) {
            self.store.send(.loginButtonTapped)
          }
          BigButton("Sign up", color: .secondary) {
            self.store.send(.signupButtonTapped)
          }
        }
      }
      .padding(.top, 80)
      .padding(.bottom, 20)
      .padding(.horizontal, 30)
    }
    .background(Gradient(colors: [.white, .b100]))
    .sheet(item: self.$store.scope(state: \.signup, action: \.signup)) { signupStore in
      NavigationStack {
        SignupView(store: signupStore)
          .navigationTitle("Create an account")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                self.store.send(.signup(.dismiss))
              }
            }
          }
      }
    }
    .sheet(item: self.$store.scope(state: \.login, action: \.login)) { loginStore in
      NavigationStack {
        LoginView(store: loginStore)
          .navigationTitle("Log into your account")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                self.store.send(.login(.dismiss))
              }
            }
          }
      }
    }
  }
}

#Preview("Unauthed") {
  UnauthedView(
    store: Store(initialState: Unauthed.State()) {
      Unauthed()
    }
  )
}

#Preview("Signing up") {
  UnauthedView(
    store: Store(
      initialState: Unauthed.State(
        signup: Signup.State()
      )
    ) {
      Unauthed()
    }
  )
}

#Preview("Logging in") {
  UnauthedView(
    store: Store(
      initialState: Unauthed.State(
        login: Login.State()
      )
    ) {
      Unauthed()
    }
  )
}
