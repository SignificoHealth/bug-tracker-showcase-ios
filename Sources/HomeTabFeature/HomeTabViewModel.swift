import Foundation
import SwiftNavigation

@Observable
public final class HomeTabViewModel {
  public init() {}

  enum TabSelection {
    case appInfo
    case about
  }

  var tabSelection: TabSelection = .appInfo
}
