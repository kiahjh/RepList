import ComposableArchitecture

extension SharedKey where Self == AppStorageKey<String?>.Default {
  static var sessionToken: Self {
    Self[.appStorage("sessionToken"), default: nil]
  }
}
