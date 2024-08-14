import CoreGraphics
import Foundation
import MarkdownUI
import SwiftUI
import UIKit

public func setUpNavigationStyle() {
  UINavigationBar.appearance().largeTitleTextAttributes = [
    .font: UIFont(name: "Metropolis", size: 40)!,
    .foregroundColor: UIColor.init(named: "primary", in: .module, compatibleWith: nil)!,
  ]
  UINavigationBar.appearance().titleTextAttributes = [
    .font: UIFont(name: "Metropolis", size: 20)!,
    .foregroundColor: UIColor.init(named: "primary", in: .module, compatibleWith: nil)!,
  ]

  UIBarButtonItem.appearance().setTitleTextAttributes(
    [.font: UIFont(name: "Metropolis", size: 16)!], for: .normal)
}

extension CGFloat {
  public enum Spacing {
    /// 24.0 points
    public static var M: CGFloat { 24.0 }
    /// 16.0 points
    public static var S: CGFloat { 16.0 }
    /// 12.0 points
    public static var XS: CGFloat { 12.0 }
    /// 8.0 points
    public static var XXS: CGFloat { 8.0 }
    /// 4.0 points
    public static var XXXS: CGFloat { 4.0 }

  }

  public enum Length {
    /// 20.0 points
    public static var M: CGFloat { 20.0 }
    /// 15.0 points
    public static var S: CGFloat { 15.0 }
    /// 10.0 points
    public static var XS: CGFloat { 10.0 }
    /// 5.0 points
    public static var XXS: CGFloat { 5.0 }
    /// 2.5 points
    public static var XXXS: CGFloat { 2.5 }
  }
}

extension Markdown {
  public func styled() -> some View {
    return markdownTextStyle(\.text) {
      FontFamily(.custom("Metropolis"))
      ForegroundColor(.Style.text)
    }
    .markdownTextStyle(\.link) {
      FontFamily(.custom("Metropolis"))
      ForegroundColor(.Style.primary)
    }
  }
}

extension Text {
  public func h1() -> some View {
    font(.Style.h1)
      .foregroundColor(.Style.primary)
      .lineSpacing(4)
  }

  public func display1() -> some View {
    font(.Style.display1)
      .foregroundColor(.Style.primary)

  }

  public func h2() -> some View {
    font(.Style.h2)
      .foregroundColor(.Style.text)
      .lineSpacing(4)
  }

  public func body() -> some View {
    font(.Style.body)
      .foregroundColor(.Style.text)
  }
}

#Preview {
  ScrollView {
    let _ = registerFonts()
    VStack(alignment: .leading, spacing: .Spacing.M) {
      let text = Text("generic_error", bundle: .module)
      text.display1()
      text.h1()
      text.h2()
      text.body()
    }
  }
}
