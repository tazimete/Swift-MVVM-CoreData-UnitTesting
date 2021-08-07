//
//  UserProfileViewModelTest.swift
//  tawktestiosTests
//
//  Created by JMC on 8/8/21.
//

import XCTest
import tawktestios
import CoreData

class UserProfileViewModelTest: XCTestCase, NSFetchedResultsControllerDelegate {
    var viewModel: UserProfileViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in = the class.
        let remoteDataSource = LocalDataSource<GithubUser, GithubUserEntity>(persistentContainer: CoreDataClientTest.shared.persistentContainer, viewContext: CoreDataClientTest.shared.backgroundContext)
        let localDataSource = RemoteDataSource<GithubApiRequest, GithubUser>(apiClient: ApiClientTest.shared)
        let service = GithubService(localDataSource: remoteDataSource, remoteDataSource: localDataSource)
        
        viewModel = UserProfileViewModel(with: service)
        viewModel.fetchedResultsController.delegate = self
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testFetchUserProfile() {
        viewModel.dataFetchingSuccessHandler = { [weak self] in
            let user = self?.viewModel.data ?? GithubUser()
            XCTAssertNotEqual(user.id, -1)
            XCTAssertNotEqual(user.username, "")
            XCTAssertEqual(user.username, "tawk")
            XCTAssertEqual(user.url, "https://api.github.com/users/tawk")
            XCTAssertEqual(user.avatarUrl, "https://avatars.githubusercontent.com/u/9743939?v=4")
            
        }
        
        viewModel.dataFetchingFailedHandler = { [weak self] in
            XCTAssertNil(self?.viewModel.data)
        }
        
        viewModel.fetchProfile(username: "tawk")
    }
    
    func testUpdateUserProfile() {
        let user = viewModel.fetchedResultsController.fetchedObjects?.first ?? GithubUserEntity()
        user.note = "test note"
        user.isSeen = true
        viewModel.updateUserEntity(user: user)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      
        switch type {
          case .insert:
            guard let index = newIndexPath else {
                return
            }
            
            let user = controller.object(at: index) as? GithubUserEntity
            XCTAssertNotNil(user)
            XCTAssertEqual(user?.note, "test note")
            XCTAssertEqual(user?.isSeen, true)
            
          case .delete:
            guard let index = indexPath else {
                return
            }
            
            let user = controller.object(at: index)
            XCTAssertNotNil(user)
            
          case .update:
            guard let index = indexPath else {
                return
            }
            
            let user = controller.object(at: index) as? GithubUserEntity
            XCTAssertNotNil(user)
            XCTAssertEqual(user?.note, "test note")
            XCTAssertEqual(user?.isSeen, true)
            
          case .move:
            guard let index = indexPath, let newIndex = indexPath else {
                return
            }
            
            let user = controller.object(at: newIndex)
            XCTAssertNotNil(user)
            
          @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
          }
    }

}
