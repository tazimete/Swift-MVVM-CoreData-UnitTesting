//
//  GithubLocalDataSourceTest.swift
//  tawktestiosTests
//
//  Created by JMC on 2/8/21.
//

import XCTest
import tawktestios

class LocalDataSourceTest: XCTestCase {

    var localDataSource: LocalDataSource<GithubUser, GithubUserEntity>!
    var users = [GithubUser]()

    override func setUp() {
        localDataSource = LocalDataSource(persistentContainer: CoreDataClientTest.shared.persistentContainer, viewContext: CoreDataClientTest.shared.backgroundContext)

        let user1 = GithubUser()
        user1.id = 10
        user1.username = "test name 1"
        user1.avatarUrl = "www.testapp.com/img/10"

        let user2 = GithubUser()
        user2.id = 11
        user2.username = "test name 2"
        user2.avatarUrl = "www.testapp.com/img/11"

        let user3 = GithubUser()
        user3.id = 12
        user3.username = "test name 3"
        user3.avatarUrl = "www.testapp.com/img/12"

        users = [user1, user2, user3]
    }

    override func tearDown() {
        localDataSource = nil
        users.removeAll()
    }

    func testInsertItems() {
        localDataSource.insertItems(items: users, taskContext: localDataSource.viewContext)
        
        let result = localDataSource.fetchItems(taskContext: localDataSource.viewContext)
        
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(users.count == result.count)
        XCTAssertNotNil(result[0].username)
        XCTAssertEqual(users[0].username, result[0].username)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
        
        //empty store 
        let ids = users.map { $0.id ?? -1 }.compactMap { $0 }
        localDataSource.batchDeleteItems(ids: ids, taskContext: localDataSource.viewContext)
    }
    
    func testFetchItems() {
        localDataSource.insertItems(items: users, taskContext: localDataSource.viewContext)
        let result = localDataSource.fetchItems(taskContext: localDataSource.viewContext)

        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(users.count == result.count)
        XCTAssertNotNil(result[0].username)
        XCTAssertEqual(users[0].username, result[0].username)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
        
        //empty store
        let ids = users.map { $0.id ?? -1 }.compactMap { $0 }
        localDataSource.batchDeleteItems(ids: ids, taskContext: localDataSource.viewContext)
    }

    func testBtachDelete(){
        localDataSource.insertItems(items: users, taskContext: localDataSource.viewContext)
        let ids = users.map { $0.id ?? -1 }.compactMap { $0 }
        localDataSource.batchDeleteItems(ids: ids, taskContext: localDataSource.viewContext)
        let result = localDataSource.fetchItems(taskContext: localDataSource.viewContext)
        
        XCTAssertEqual(result.count, 0)
        XCTAssertNotEqual(users.count, result.count)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
        XCTAssertNil(result.first)
    }
    
    func testSyncData(){
        let isSuccess = localDataSource.syncData(data: users, taskContext: localDataSource.viewContext)
//        let ids = users.map({$0.id ?? -1})
//        localDataSource.batchDeleteItems(ids: ids, taskContext: CoreDataClientTest.shared.backgroundContext)
        let result = localDataSource.fetchItems(taskContext: localDataSource.viewContext)
        
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(users.count == result.count)
        XCTAssertNotNil(result[0].username)
        XCTAssertEqual(users[0].username, result[0].username)
        XCTAssertNotEqual(users.first?.username, result.last?.username)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
