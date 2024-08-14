import Foundation

/// Allows us to use a closure in cases where identity needs to be derived
///
public struct CompletionBlock<A>: Identifiable {
  public init(run: @escaping (A) -> Void) {
    self.run = run
  }

  public let id = UUID()
  public let run: (A) -> Void
}
