import ComposableArchitecture
import SwiftUI

@Reducer
struct PieceDetail: Equatable {
  @ObservableState
  struct State: Equatable {
    let piece: Piece
  }

  enum Action {}

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {}
    }
  }
}

struct PieceDetailView: View {
  let store: StoreOf<PieceDetail>

  var body: some View {
    Text(store.piece.title)
  }
}

#Preview {
  PieceDetailView(
    store: Store(initialState: PieceDetail.State(piece: Piece.example())) {
      PieceDetail()
    }
  )
}
