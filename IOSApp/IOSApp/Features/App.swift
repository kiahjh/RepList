import ComposableArchitecture

@Reducer
struct AppFeature {
  @ObservableState
  struct State {}

  enum Action {}

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {}
    }
  }
}
