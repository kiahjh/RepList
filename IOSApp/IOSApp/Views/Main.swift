import SwiftUI

struct Main: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    TabView {
      Tab("Repertoire", systemImage: "music.note.list") {
        RepertoireList()
      }
      Tab("Friends", systemImage: "person.2") {
        FriendsList()
      }
      Tab("Profile", systemImage: "person.crop.circle") {
        Profile()
      }
    }
  }
}

#Preview {
  Main()
    .environmentObject(AppState())
}
