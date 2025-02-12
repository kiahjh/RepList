import ComposableArchitecture
import SwiftUI

@Reducer
struct UserDetail: Equatable {
  @ObservableState
  struct State: Equatable {
    @Shared(.sessionToken) var sessionToken
  }

  enum Action {
    case loggoutButtonTapped
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .loggoutButtonTapped:
        state.$sessionToken.withLock { $0 = nil }
        return .none
      }
    }
  }
}

struct UserDetailView: View {
  let store: StoreOf<UserDetail>

  var body: some View {
    VStack {
      Text("User Detail")
      Button("Log out") {
        store.send(.loggoutButtonTapped)
      }
    }
  }
}

#Preview {
  UserDetailView(
    store: Store(
      initialState: UserDetail.State()
    ) {
      UserDetail()
    }
  )
}
