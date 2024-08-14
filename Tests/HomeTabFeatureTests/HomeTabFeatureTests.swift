import XCTest
import Dependencies
import Entities
import ConcurrencyExtras
import Logging
import Logger

@testable import HomeTabFeature

final class HomeTabFeatureTests: XCTestCase {
    func testInitialStateOnHomeTabViewModel() throws {
        let viewModel = HomeTabViewModel()

        XCTAssertEqual(viewModel.tabSelection, .appInfo)
    }
    
    func testInitialStateOnHomeAppInfoViewModel() {
        let viewModel = AppInfoViewModel()
        XCTAssertNil(viewModel.user)
        XCTAssertNil(viewModel.error)
        XCTAssertNil(viewModel.destination)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testGetUserCallsRepoAndManagesStateCorrectly() async throws {
        await withMainSerialExecutor {
            let viewModel = withDependencies {
                // mocking the getUser endpoint
                $0.githubRepo.getUser = {
                    // simulating the async operation, without this line the test would not work
                    // as the system KNOWS that this function did not ever need
                    // to wait for any work to be done
                    try await Task.sleep(until: .now)
                    return mockUser
                }
            } operation: {
                AppInfoViewModel()
            }
            
            // we construct the task and make sure it has done everything it has to do
            // until it needs to await. We yield so that when it needs to await, it returns
            // execution to the test so that we can verify the state at that point.
            // this is because we are using withMainSerialExecutor {}
            
            let task = Task { try? await viewModel.getGithubUser() }
            await Task.yield()
            
            XCTAssertTrue(viewModel.isLoading)
            
            // we continue the execution
            await task.value
            
            XCTAssertNil(viewModel.error)
            XCTAssertEqual(viewModel.user, mockUser)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(TestLogger.messagesReceived.count, 0)
        }
    }
    
    func testGetUserCallsRepoAndManagesStateCorrectlyWhenError() async throws {
        await withMainSerialExecutor {
            let viewModel = withDependencies {
                $0.githubRepo.getUser = {
                    try await Task.sleep(until: .now)
                    throw NSError(domain: "", code: 0, userInfo: [:])
                }
            } operation: {
                AppInfoViewModel()
            }
            
            let task = Task { try? await viewModel.getGithubUser() }
            await Task.yield()
            
            XCTAssertTrue(viewModel.isLoading)
            
            await task.value
            
            XCTAssertNil(viewModel.user)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNotNil(viewModel.error)
            XCTAssertEqual(TestLogger.messagesReceived.count, 1)
        }
    }
    
    func testTappingButtonActionModifiesNavigationState() {
        let viewModel = AppInfoViewModel()
        
        XCTAssertNil(viewModel.destination)
        
        viewModel.startButtonTapped()
        
        XCTAssertEqual(viewModel.destination, .issues)
    }
}

let mockUser = GithubUser(
    id: 100,
    name: "Chema",
    email: "chema.rubio@significo.com",
    login: "cr.significo",
    avatarUrl: URL(string: "https://made-up-url.com")!
)

