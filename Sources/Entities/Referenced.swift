import Foundation
import SwiftUI

/// Facilitates propagation from Referenced to Binding wrapped source.
/// - Important: Needs modifications if Binding to Referenced propagation is desired.
///
public final class Referenced<T: Equatable>: Equatable {
  public static func == (lhs: Referenced<T>, rhs: Referenced<T>) -> Bool {
    lhs.wrapped == rhs.wrapped
  }

  private let binding: Binding<T>

  public init(binding: Binding<T>) {
    self.binding = binding
    self.wrapped = binding.wrappedValue
  }

  public var wrapped: T {
    willSet {
      binding.wrappedValue = newValue
    }
  }
}
