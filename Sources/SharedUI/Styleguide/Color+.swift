import SwiftUI

extension Color {
  public enum Style {
    public static var primary: Color {
      .init("primary", bundle: .module)
    }

    public static var secondary: Color {
      .init("secondary", bundle: .module)
    }

    public static var text: Color {
      .init("text", bundle: .module)
    }

    public static var background: Color {
      .init("background", bundle: .module)
    }

    public static var background2: Color {
      .init("background2", bundle: .module)
    }
  }
}
