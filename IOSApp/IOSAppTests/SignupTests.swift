import Testing
@testable import IOSApp

struct SignupTests {
  @MainActor
  @Test
  func basics() async throws {
    let model = SignupModel()
    
    model.username = "loremipsum"
    model.password = "short"
    model.email = "invalid"
    
    #expect(model.isValidForm == false)
    
    model.password = "longenough"
    
    #expect(model.isValidForm == false) // becasue email is still invalid
    
    model.email = "valid@example.com"
    
    #expect(model.isValidForm == true)
    
    // TODO: mock api client dependency so that `.signup()` endpoint can be tested in here
  }
}
