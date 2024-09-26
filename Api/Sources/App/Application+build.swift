import Hummingbird
import Logging
import Models

/// Application arguments protocol. We use a protocol so we can call
/// `buildApplication` inside Tests as well as in the App executable.
/// Any variables added here also have to be added to `App` in App.swift and
/// `TestArguments` in AppTest.swift
public protocol AppArguments {
  var hostname: String { get }
  var port: Int { get }
  var logLevel: Logger.Level? { get }
}

extension User: ResponseEncodable {}

public func buildApplication(_ arguments: some AppArguments) async throws
  -> some ApplicationProtocol {
  let environment = Environment()
  let logger = {
    var logger = Logger(label: "Api")
    logger.logLevel =
      arguments.logLevel ??
      environment.get("LOG_LEVEL").map { Logger.Level(rawValue: $0) ?? .info } ??
      .info
    return logger
  }()
  let router = Router()

  // Add logging
  router.add(middleware: LogRequestsMiddleware(.info))
  // Add health endpoint
  router.get("/health") { _, _ -> HTTPResponse.Status in
    .ok
  }

  router.post("/login") { req, ctx in
    print("in the login route")
    let input = try await req.decode(as: Input.self, context: ctx)

    print(input)

    if input.password == "good" {
      return User(name: input.username, id: .init())
    }

    throw HTTPError(.unauthorized)
  }

  let app = Application(
    router: router,
    configuration: .init(
      address: .hostname(arguments.hostname, port: arguments.port),
      serverName: "Api"
    ),
    logger: logger
  )
  return app
}

struct Input: Decodable {
  let username: String
  let password: String
}
