import ComposableArchitecture
import Testing

@testable import IOSApp

@MainActor
struct LoginFeatureTests {
  @Test
  func happyPath() async {
    let store = TestStore(
      initialState: Login.State()
    ) {
      Login()
    }

    #expect(store.state.password == "")
    #expect(store.state.username == "")
    #expect(store.state.errorMessage == nil)

    await store.send(.binding(.set(\.password, "password"))) {
      $0.password = "password"
    }
    await store.send(.binding(.set(\.username, "foo_87"))) {
      $0.username = "foo_87"
    }

    await store.send(.loginButtonTapped)
    await store.receive(\.setSessionToken) {
      $0.$sessionToken.withLock { $0 = "test-session-token" }
    }
  }

  @Test
  func failingRequest() async {
    let store = TestStore(
      initialState: Login.State()
    ) {
      Login()
    } withDependencies: {
      $0.apiClient = APIClient(fetcher: FailingFetcher())
    }

    #expect(store.state.password == "")
    #expect(store.state.username == "")
    #expect(store.state.errorMessage == nil)

    await store.send(.binding(.set(\.password, "password"))) {
      $0.password = "password"
    }
    await store.send(.binding(.set(\.username, "foo_87"))) {
      $0.username = "foo_87"
    }

    await store.send(.loginButtonTapped)
    await store.receive(\.setErrorMessage) {
      $0.errorMessage = "test-error"
    }
  }
}
