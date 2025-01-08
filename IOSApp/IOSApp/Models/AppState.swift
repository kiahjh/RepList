import SwiftUI

class AppState: ObservableObject {
  @Published var sessionToken: String? = nil
  @Published var loggingIn = false
  @Published var signingIn = false

  @Published var songs: [Song] = [
    Song(id: UUID(), title: "Prelude in C Major", composer: "Johann Sebastian Bach", year: 1722),
    Song(id: UUID(), title: "Sonata in C Major", composer: "Wolfgang Amadeus Mozart", year: 1788),
    Song(id: UUID(), title: "Sonata in C Major", composer: "Ludwig van Beethoven", year: 1801),
    Song(id: UUID(), title: "Nocturne in E-flat Major", composer: "Frédéric Chopin", year: 1830),
    Song(
      id: UUID(),
      title: "Prelude in C-sharp Minor",
      composer: "Sergei Rachmaninoff",
      year: 1892
    ),
    Song(id: UUID(), title: "Sonata in B-flat Minor", composer: "Franz Liszt", year: 1853),
    Song(id: UUID(), title: "Sonata in B Minor", composer: "Franz Liszt", year: 1853),
  ]

  init(loggingIn: Bool = false, signingUp: Bool = false) {
    self.loggingIn = loggingIn
    self.signingIn = signingUp
    self.sessionToken = keychain.get("session_token")
  }
}

struct Song: Identifiable {
  var id: UUID
  var title: String
  var composer: String?
  var year: Int?
}
