import SwiftUI

struct RepertoireList: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    NavigationView {
      List {
        ForEach(self.appState.songs) { song in
          NavigationLink(destination: Text(song.title)) {
            Text(song.title)
          }
        }
      }
      .navigationTitle("In progress")
    }
  }
}

#Preview {
  RepertoireList()
    .environmentObject(AppState())
}
