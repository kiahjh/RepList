import ComposableArchitecture
import Sharing
import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      RepertoireListView(
        store: Store(initialState: RepertoireList.State(
          pieces: Piece.list
        )) {
          RepertoireList()
        }
      )
    }
  }
}

#Preview {
  ContentView()
}
