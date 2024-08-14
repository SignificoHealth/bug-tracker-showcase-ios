import Dependencies
import Foundation
import Logging
import LoggingOSLog

public enum LoggerDependencyKey: DependencyKey {
  public static var liveValue: Logger {
    return Logger(label: "com.significo.bug-tracker")
  }

  public static var testValue: Logger {
    Logger(
      label: "com.significo.test-logger",
      factory: { label in
        TestLogger()
      })
  }
}

/// here you could bootstrap other logging systems
public func initialize() {
  LoggingSystem.bootstrap(LoggingOSLog.init)
}

extension DependencyValues {
  public var logger: Logger {
    get { self[LoggerDependencyKey.self] }
    set { self[LoggerDependencyKey.self] = newValue }
  }
}

public class TestLogger: LogHandler {
  public var metadata = Logger.Metadata()
  public var logLevel: Logger.Level = .warning
  public static var messagesReceived: [Logger.Message] = []

  public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
    get {
      return self.metadata[metadataKey]
    }
    set {
      self.metadata[metadataKey] = newValue
    }
  }

  public func log(
    level: Logger.Level,
    message: Logger.Message,
    metadata: Logger.Metadata?,
    source: String,
    file: String,
    function: String,
    line: UInt
  ) {
    TestLogger.messagesReceived.append(message)
  }

  deinit {
    TestLogger.messagesReceived = []
  }
}
