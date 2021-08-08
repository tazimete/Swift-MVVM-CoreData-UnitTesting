//
//  ViewModelTest.swift
//  tawktestiosTests
//
//  Created by JMC on 3/8/21.
//

import XCTest
import tawktestios
import CoreData

class GithubViewModelTest: XCTestCase, NSFetchedResultsControllerDelegate {
    var viewModel: GithubViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in = the class.
        let localDataSource = LocalDataSource<GithubUser, GithubUserEntity>(persistentContainer: CoreDataClientTest.shared.persistentContainer, viewContext: CoreDataClientTest.shared.backgroundContext)
        let remoteDataSource = RemoteDataSource<GithubApiRequest, GithubUser>(apiClient: ApiClientTest.shared)
        let service = GithubService(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        
        viewModel = GithubViewModel(with: service)
        viewModel.fetchedResultsController.delegate = self
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testFetchUserList() {
        viewModel.dataFetchingSuccessHandler = { [weak self] in
            let user = (self?.viewModel.fetchedResultsController.fetchedObjects?.first)?.asGithubUser
            XCTAssertNotEqual(self?.viewModel.fetchedResultsController.fetchedObjects?.count ?? 0, 0)
            XCTAssertNotNil(user)
            XCTAssertNotEqual(user?.username, self?.viewModel.fetchedResultsController.fetchedObjects?.last?.username)
        }
        
        viewModel.dataFetchingFailedHandler = { [weak self] in
            XCTAssertEqual(self?.viewModel.fetchedResultsController.fetchedObjects?.count ?? 0, 0)
        }
        
        viewModel.fetchUserList(since: viewModel.paginationlimit)
    }
    
    func testSearchUser() {
        viewModel.dataFetchingSuccessHandler = { [weak self] in
            guard let user = (self?.viewModel.fetchedResultsController.fetchedObjects?.first)?.asGithubUser else {
                XCTFail("Empty user obejct")
                return
            }
            
            XCTAssertNotNil(user)
            self?.viewModel.searchUser(searchText: user.username ?? "")
        }
        
        viewModel.fetchUserList(since: viewModel.paginationlimit)
    }
    
    func testClearSearchUser() {
        viewModel.dataFetchingSuccessHandler = { [weak self] in
            guard let user = (self?.viewModel.fetchedResultsController.fetchedObjects?.first)?.asGithubUser else {
                XCTFail("Empty user obejct")
                return
            }
            
            XCTAssertNotNil(user)
            self?.viewModel.clearSearch()
        }
        
        viewModel.fetchUserList(since: viewModel.paginationlimit)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      
        switch type {
          case .insert:
            guard let index = newIndexPath else {
                return
            }
            
            let user = controller.object(at: index)
            XCTAssertNotNil(user)
            
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
            
            let user = controller.object(at: index)
            XCTAssertNotNil(user)
            
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
