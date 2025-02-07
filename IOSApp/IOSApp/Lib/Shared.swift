import ComposableArchitecture

extension SharedKey where Self == AppStorageKey<String?>.Default {
  static var sessionToken: Self {
    Self[.appStorage("sessionToken"), default: nil]
  }
}


struct ListSectionCollapsedState: Codable {
  var learning: Bool
  var next: Bool
  var needsWork: Bool
  var learned: Bool
}

extension SharedKey where Self == FileStorageKey<ListSectionCollapsedState>.Default {
  static var listSectionCollapsedState: Self {
    Self[
      .fileStorage(
        .documentsDirectory.appending(component: "__replist_listSectionCollapsedState.json")
      ),
      default: ListSectionCollapsedState(learning: false, next: false, needsWork: false, learned: false)
    ]
  }
}
