import Dependencies
import Foundation
import Repository
import SharedUI
import SwiftUI
import SwiftUINavigation

public struct HomeTabView: View {
  @State var viewModel: HomeTabViewModel

  public init(viewModel: HomeTabViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    TabView(
      selection: $viewModel.tabSelection,
      content: {
        withDependencies(from: viewModel) {
          AppInfoView()
        }
        .tabItem {
          VStack {
            Image(systemName: "house")
            Text("home", bundle: .module)
              .body()
          }
        }
        .tag(HomeTabViewModel.TabSelection.appInfo)

        withDependencies(from: viewModel) {
          AboutView()
        }
        .tabItem {
          VStack {
            Image(systemName: "info.circle")
            Text("about", bundle: .module)
              .body()
          }
        }
        .tag(HomeTabViewModel.TabSelection.about)
      }
    )
    .tint(.Style.primary)
  }
}

#Preview {
  HomeTabView(
    viewModel: withDependencies {
      $0.githubRepo = .liveValue
    } operation: {
      SharedUI.registerFonts()
      SharedUI.setUpNavigationStyle()
      return HomeTabViewModel()
    }
  )
}
