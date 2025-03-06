import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
  @ObservableState
  struct State {
    @Shared(.sessionToken) var sessionToken
  }

  enum Action {}

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {}
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    // TODO: for testability, this should be state driven in the reducer
    if store.sessionToken != nil {
      NavigationStack {
        RepertoireListView(
          store: Store(
            initialState: RepertoireList.State()
          ) {
            RepertoireList()
          }
        )
      }
    } else {
      UnauthedView(
        store: Store(
          initialState: Unauthed.State()
        ) {
          Unauthed()
        }
      )
    }
  }
}

#Preview {
  AppView(
    store: Store(initialState: AppFeature.State()) {
      AppFeature()
    }
  )
}
