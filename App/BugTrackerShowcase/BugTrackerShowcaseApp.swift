import Dependencies
import HomeTabFeature
import Logger
import Repository
import SharedUI
import SwiftUI

@main
struct BugTrackerShowcaseApp: App {
  init() {
    SharedUI.registerFonts()
    SharedUI.setUpNavigationStyle()
    Logger.initialize()
  }

  var body: some Scene {
    WindowGroup {
      HomeTabView(
        viewModel: withDependencies {
          $0.githubRepo = .liveValue
        } operation: {
          HomeTabViewModel()
        }
      )
    }
  }
}
