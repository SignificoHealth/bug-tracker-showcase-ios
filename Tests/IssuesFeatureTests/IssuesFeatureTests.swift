import XCTest
import Dependencies
import Entities
import ConcurrencyExtras
import Logging
import Logger

@testable import IssuesFeature

final class IssuesFeatureTests: XCTestCase {
    private var viewModel: IssuesViewModel!
    
    override func setUp() {
        viewModel = IssuesViewModel()
    }
    
    // MARK: IssuesViewModel
    
    func testInitialStateOnIssuesInfoViewModel() {
        XCTAssertNil(viewModel.issues)
        XCTAssertNil(viewModel.error)
        XCTAssertNil(viewModel.destination)
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testTappingOnIssueChangesNavigation() {
        let referenced = Referenced(binding: .constant(mockIssue))
        viewModel.tapped(issue: referenced)
        
        XCTAssertEqual(viewModel.destination, .issue(referenced))
    }
    
    func testTappingOnNewChangesNavigation() {
        viewModel.tappedNewButton()
        
        if case .new = viewModel.destination {
            // test passes
        } else {
            XCTFail("Destination should be .new")
        }
    }
    
    func testGetIssuesCallsRepoAndManagesStateCorrectly() async throws {
        try await withMainSerialExecutor {
            viewModel = withDependencies {
                $0.githubRepo.listIssues = {
                    try await Task.sleep(until: .now)
                    return [mockIssue]
                }
            } operation: {
                IssuesViewModel()
            }
            
            let task = Task { try await viewModel.getIssues() }
            await Task.yield()
            
            XCTAssertNil(viewModel.issues)
            XCTAssertTrue(viewModel.isLoading)
            
            try await task.value
            
            XCTAssertEqual(viewModel.issues, [mockIssue])
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.error)
            XCTAssertEqual(TestLogger.messagesReceived.count, 0)
        }
    }
    
    func testGetIssuesCallsRepoAndManagesStateCorrectlyWhenError() async throws {
        await withMainSerialExecutor {
            viewModel = withDependencies {
                $0.githubRepo.listIssues = {
                    try await Task.sleep(until: .now)
                    throw NSError(domain: "", code: 0, userInfo: [:])
                }
            } operation: {
                IssuesViewModel()
            }
            
            let task = Task { try await viewModel.getIssues() }
            await Task.yield()
            
            XCTAssertNil(viewModel.issues)
            XCTAssertTrue(viewModel.isLoading)
            
            try? await task.value
            
            XCTAssertNil(viewModel.issues)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNotNil(viewModel.error)
            XCTAssertEqual(TestLogger.messagesReceived.count, 1)
        }
    }
    
    // MARK: CreateIssueViewModel
    // MARK: EditIssueViewModel
}

let mockIssue = GithubIssue(
    id: 1,
    number: 1,
    state: .open,
    title: "This is a mock issue",
    body: "## Some markdown body",
    user: .init(
        id: 100,
        name: "Chema",
        email: "chema.rubio@significo.com",
        login: "cr.significo",
        avatarUrl: URL(string: "https://made-up-url.com")!
    ),
    labels: [],
    assignee: nil,
    assignees: nil,
    comments: 2,
    closedAt: nil,
    createdAt: .now - (60 * 60 * 24 * 2),
    updatedAt: .now - (60 * 60 * 24)
)
