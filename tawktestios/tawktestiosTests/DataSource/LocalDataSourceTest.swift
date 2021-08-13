//
//  GithubLocalDataSourceTest.swift
//  tawktestiosTests
//
//  Created by JMC on 2/8/21.
//

import XCTest
import tawktestios
import CoreData

class LocalDataSourceTest: XCTestCase {

    var localDataSource: LocalDataSource<GithubUser, GithubUserEntity>!
    var users = [GithubUser]()

    override func setUp() {
        super.setUp()
        localDataSource = LocalDataSource(persistentContainer: CoreDataClientTest.shared.persistentContainer, viewContext: CoreDataClientTest.shared.backgroundContext)

        let user1 = GithubUser()
        user1.id = 10
        user1.username = "test name 10"
        user1.avatarUrl = "www.testapp.com/img/10"
        user1.url = "www.testapp.com/profile/10"
        user1.note = "test note 10"
        user1.company = "test company 10"
        user1.blog = "test blog 10"
        user1.followers = 1000
        user1.followings = 1001
        user1.isSeen = false

        let user2 = GithubUser()
        user2.id = 11
        user2.username = "test name 11"
        user2.avatarUrl = "www.testapp.com/img/11"
        user2.url = "www.testapp.com/profile/11"
        user2.note = "test note 11"
        user2.company = "test company 11"
        user2.blog = "test blog 11"
        user2.followers = 1100
        user2.followings = 1101
        user2.isSeen = true

        let user3 = GithubUser()
        user3.id = 12
        user3.username = "test name 12"
        user3.avatarUrl = "www.testapp.com/img/12"
        user3.url = "www.testapp.com/profile/12"
        user3.note = "test note 12"
        user3.company = "test company 12"
        user3.blog = "test blog 12"
        user3.followers = 1200
        user3.followings = 1201
        user3.isSeen = false

        users = [user1, user2, user3]
    }

    override func tearDown() {
        super.tearDown()
        users.removeAll()
        localDataSource.deleteAllItems(taskContext: CoreDataClientTest.shared.backgroundContext)
        localDataSource = nil
    }

    func testInsertItems() {
        localDataSource.insertItems(items: users, taskContext: localDataSource.viewContext)
        
        let result = localDataSource.fetchItems(taskContext: CoreDataClientTest.shared.mainContext)
        
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(users.count == result.count)
        XCTAssertNotNil(result[0].username)
        XCTAssertEqual(users[0].username, result[0].username)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
    }
    
    func testFetchItems() {
        localDataSource.insertItems(items: users, taskContext: localDataSource.viewContext)
        let result = localDataSource.fetchItems(taskContext: CoreDataClientTest.shared.mainContext)

        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(users.count == result.count)
        XCTAssertNotNil(result[0].username)
        XCTAssertEqual(users[0].username, result[0].username)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
    }

    func testBtachDelete() {
        localDataSource.insertItems(items: users, taskContext: localDataSource.viewContext)
        
        let ids = users.map { $0.id ?? -1 }.compactMap { $0 }
        localDataSource.batchDeleteItems(ids: ids, taskContext: localDataSource.viewContext)
        let result = localDataSource.fetchItems(taskContext: CoreDataClientTest.shared.mainContext)
        
        XCTAssertEqual(result.count, 0)
        XCTAssertNotEqual(users.count, result.count)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
        XCTAssertNil(result.first)
    }
    
    func testSyncData() {
        // insert first to set preloaded user with id=12
        let user4 = GithubUser()
        user4.id = 12
        user4.username = "test name 12"
        user4.avatarUrl = "www.testapp.com/img/12"
        user4.url = "www.testapp.com/profile/12"
        user4.note = "test note 12"
        user4.company = "test company 12"
        user4.blog = "test blog 12"
        user4.followers = 1200
        user4.followings = 1201
        user4.isSeen = false

        localDataSource.insertItems(items: [user4], taskContext: localDataSource.viewContext)
        
        //users array have another user with id=12
        let isSuccess = localDataSource.syncData(data: users, taskContext: localDataSource.viewContext)
        
        // so we have user with id = 12 twice now, sync method will sync these double user data and make it only one. We are supposed to have 4 data in user entity but we have 3 now, because of syncing
        let result = localDataSource.fetchItems(taskContext: CoreDataClientTest.shared.mainContext)
        
        XCTAssertTrue(isSuccess)
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(users.count == result.count)
        XCTAssertNotNil(result[0].username)
        XCTAssertEqual(users[0].username, result[0].username)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
    }
    
    func testSearch() {
        let remoteDataSource = RemoteDataSource<GithubApiRequest, GithubUser>(apiClient: ApiClientTest.shared)
        let service = GithubService(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        
        let viewModel = GithubViewModel(with: service)
        viewModel.fetchedResultsControllerDelegate = FetchResultControllerDeleagte()
        localDataSource.search(params: ["username": "test name 2", "note": "test note"], controller: viewModel.fetchedResultsController, isEnded: false)
    }
    
    func testClearSearch() {
        let remoteDataSource = RemoteDataSource<GithubApiRequest, GithubUser>(apiClient: ApiClientTest.shared)
        let service = GithubService(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        
        let viewModel = GithubViewModel(with: service)
        viewModel.fetchedResultsControllerDelegate = FetchResultControllerDeleagte()
        localDataSource.clearSearch(controller: viewModel.fetchedResultsController)
    }
}



class FetchResultControllerDeleagte: NSObject, NSFetchedResultsControllerDelegate {
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
