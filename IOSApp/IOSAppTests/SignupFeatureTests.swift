import ComposableArchitecture
import Testing

@testable import IOSApp

@MainActor
struct SignupFeatureTests {
  @Test
  func happyPath() async {
    let store = TestStore(
      initialState: Signup.State()
    ) {
      Signup()
    }

    #expect(store.state.email == "")
    #expect(store.state.password == "")
    #expect(store.state.username == "")
    #expect(store.state.errorMessage == nil)

    await store.send(.binding(.set(\.email, "foo@bar.com"))) {
      $0.email = "foo@bar.com"
    }
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
      initialState: Signup.State()
    ) {
      Signup()
    } withDependencies: {
      $0.apiClient = APIClient(fetcher: FailingFetcher())
    }

    #expect(store.state.email == "")
    #expect(store.state.password == "")
    #expect(store.state.username == "")
    #expect(store.state.errorMessage == nil)

    await store.send(.binding(.set(\.email, "foo@bar.com"))) {
      $0.email = "foo@bar.com"
    }
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
