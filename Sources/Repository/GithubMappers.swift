import API
import Entities
import Foundation

// MARK: DTO -> Entitiy

extension GithubUser {
  init(dto: UserDTO) throws {
    self.init(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      login: dto.login,
      avatarUrl: try .init(string: dto.avatar_url)
    )
  }
}

extension GithubIssueState {
  init(dto: IssueStateDTO) {
    switch dto {
    case .open:
      self = .open
    case .closed:
      self = .closed
    }
  }
}

extension GithubIssueLabel {
  init(dto: LabelDTO) {
    self.init(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      color: dto.color
    )
  }
}

extension GithubIssue {
  init(dto: IssueDTO) throws {
    let dateFormatter = ISO8601DateFormatter()
    struct UnexpectedDateFormat: LocalizedError {
      let date: String

      var errorDescription: String {
        "Unexpected date format \(date)"
      }
    }

    guard let createdAt = dateFormatter.date(from: dto.created_at) else {
      throw UnexpectedDateFormat(date: dto.created_at)
    }

    guard let updatedAt = dateFormatter.date(from: dto.updated_at) else {
      throw UnexpectedDateFormat(date: dto.updated_at)
    }

    self.init(
      id: dto.id,
      number: dto.number,
      state: .init(dto: dto.state),
      title: dto.title,
      body: dto.body,
      user: try dto.user.map(GithubUser.init),
      labels: dto.labels.map(GithubIssueLabel.init),
      assignee: try dto.assignee.map(GithubUser.init),
      assignees: try dto.assignees.map { array in try array.map(GithubUser.init) },
      comments: dto.comments,
      closedAt: dto.closed_at.flatMap(dateFormatter.date(from:)),
      createdAt: createdAt,
      updatedAt: updatedAt
    )
  }
}

extension URL {
  struct InvalidURL: LocalizedError {
    let url: String

    var errorDescription: String? {
      "Invalid url: \(url)"
    }
  }

  init(string: String) throws {
    if let url = URL(string: string) {
      self = url
    } else {
      throw InvalidURL(url: string)
    }
  }
}

extension GithubBranchFile {
  init(dto: FileContentDTO) throws {
    self.init(
      name: dto.name,
      path: dto.path,
      sha: dto.sha,
      size: dto.size,
      url: try .init(string: dto.url),
      htmlUrl: try .init(string: dto.html_url),
      gitUrl: try .init(string: dto.git_url),
      downloadUrl: try .init(string: dto.download_url),
      type: dto.type
    )
  }
}

extension CreateGithubBranchFileResponse {
  init(dto: CreateFileResponseDTO) throws {
    self.init(
      content: try .init(dto: dto.content)
    )
  }
}

// MARK: Entity -> DTO

extension IssueStateDTO {
  init(entity: GithubIssueState) {
    switch entity {
    case .open:
      self = .open
    case .closed:
      self = .closed
    }
  }
}

extension UserDTO {
  init(entity: GithubUser) {
    self.init(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      login: entity.login,
      avatar_url: entity.avatarUrl.absoluteString
    )
  }
}

extension LabelDTO {
  init(entity: GithubIssueLabel) {
    self.init(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      color: entity.color
    )
  }
}

extension IssueDTO {
  init(entity: GithubIssue) {
    let formatter = ISO8601DateFormatter()

    self.init(
      id: entity.id,
      number: entity.number,
      state: .init(entity: entity.state),
      title: entity.title,
      body: entity.body,
      user: entity.user.map(UserDTO.init),
      labels: entity.labels.map(LabelDTO.init),
      assignee: entity.assignee.map(UserDTO.init),
      assignees: entity.assignees.map { array in array.map(UserDTO.init) },
      comments: entity.comments,
      closed_at: entity.closedAt.map(formatter.string),
      created_at: formatter.string(from: entity.createdAt),
      updated_at: formatter.string(from: entity.updatedAt)
    )
  }
}

extension CreateFileRequestDTO {
  init(entity: CreateGithubBranchFileRequest) {
    self.init(
      message: entity.message,
      content: entity.content,
      branch: entity.branch
    )
  }
}

extension CreateIssueDTO {
  init(entity: CreateIssueRequest) {
    self.init(
      title: entity.title,
      body: entity.body
    )
  }
}
