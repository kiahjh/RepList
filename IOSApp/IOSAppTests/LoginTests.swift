import Testing
@testable import IOSApp

struct LoginTests {
  @MainActor
  @Test
  func basics() async throws {
    let model = LoginModel()
    
    model.username = "loremipsum"
    model.password = "short"
    
    #expect(model.isValidForm == false)
    
    model.password = "longenough"
    
    #expect(model.isValidForm == true)
    
    // TODO: mock api client dependency so that `.signup()` endpoint can be tested in here
  }
}

