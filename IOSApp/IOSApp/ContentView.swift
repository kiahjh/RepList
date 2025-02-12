import ComposableArchitecture
import Sharing
import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      AppView(
        store: Store(initialState: AppFeature.State()) {
          AppFeature()
        }
      )
    }
  }
}

#Preview {
  ContentView()
}
