import Entities
import SwiftUI

public struct GithubIssueStateView: View {
  var state: GithubIssueState

  public init(state: GithubIssueState) {
    self.state = state
  }

  private var color: Color {
    state == .open ? Color.green : .purple
  }

  public var body: some View {
    HStack {
      Image(systemName: state == .open ? "circle.circle" : "checkmark.circle")
        .renderingMode(.template)
        .resizable()
        .foregroundColor(.white)
        .frame(width: .Length.M, height: .Length.M)
        .bold()

      Text(state == .open ? "open" : "closed", bundle: .module)
        .foregroundColor(.white)
        .body()
        .bold()
    }
    .padding(.horizontal, .Spacing.XS)
    .padding(.vertical, .Spacing.XXXS)
    .background {
      RoundedRectangle(cornerSize: .init(width: .Length.XS, height: .Length.XS))
        .fill(color)
    }
  }
}

#Preview {
  GithubIssueStateView(state: .closed)
}
