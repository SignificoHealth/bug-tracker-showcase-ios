import Foundation
import SwiftUI
import UIKit

let fontNames = [
  "Metropolis-Black",
  "Metropolis-BlackItalic",
  "Metropolis-Bold",
  "Metropolis-BoldItalic",
  "Metropolis-ExtraBold",
  "Metropolis-ExtraBoldItalic",
  "Metropolis-ExtraLight",
  "Metropolis-ExtraLightItalic",
  "Metropolis-Light",
  "Metropolis-LightItalic",
  "Metropolis-Medium",
  "Metropolis-MediumItalic",
  "Metropolis-Regular",
  "Metropolis-RegularItalic",
  "Metropolis-SemiBold",
  "Metropolis-SemiBoldItalic",
  "Metropolis-Thin",
  "Metropolis-ThinItalic",
]

private(set) var fontsRegistered: Bool = false

public func registerFonts() {
  if !fontsRegistered {
    let registered = fontNames.map { name in
      registerFont(bundle: .module, fontName: name, fontExtension: "otf")
    }
    .allSatisfy { $0 }

    fontsRegistered = registered
  }
}

func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
  guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
    let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
    let font = CGFont(fontDataProvider)
  else {
    fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
  }

  var error: Unmanaged<CFError>?
  return CTFontManagerRegisterGraphicsFont(font, &error)
}

extension Font {
  public enum Style {
    public static var display1: Font {
      return Font.custom("Metropolis", size: 56)
        .weight(.medium)
    }

    public static var h1: Font {
      return Font.custom("Metropolis", size: 24)
        .weight(.bold)
    }

    public static var h2: Font {
      return Font.custom("Metropolis", size: 24)
        .weight(.medium)
    }

    public static var body: Font {
      return Font.custom("Metropolis", size: 16)
        .weight(.regular)
    }
  }
}
