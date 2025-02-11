import ComposableArchitecture
import SwiftUI

@Reducer
struct Unauthed {
  @ObservableState
  struct State: Equatable {
    @Presents var signup: Signup.State?
  }

  enum Action {
    case signupButtonTapped
    case signup(PresentationAction<Signup.Action>)
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .signupButtonTapped:
        state.signup = Signup.State()
        return .none
      case .signup:
        return .none
      }
    }
    .ifLet(\.$signup, action: \.signup) {
      Signup()
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
          BigButton("Log in", color: .primary) {}
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
