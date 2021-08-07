//
//  RemoteDataSourceTest.swift
//  tawktestiosTests
//
//  Created by JMC on 3/8/21.
//

import XCTest
import tawktestios

class RemoteDataSourceTest: XCTestCase {
    var remoteDataSource: RemoteDataSource<GithubApiRequest, GithubUser>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        remoteDataSource = RemoteDataSource(apiClient: ApiClientTest.shared)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        remoteDataSource = nil
    }

    func testFetchDataList() {
        remoteDataSource.fetchDataList(request: .fetchUserList(params: FetchGithubUserParam(since: 20))){ result in
            switch result{
                case .success(let users):
                    print("fetchData() -- \(users.map({$0.username}))")
                    
                    XCTAssertNotEqual(users.count, 0)
                    XCTAssertNotEqual(users.first?.username, users.last?.username)
                case .failure(let error):
                    print("\(String(describing: (error).localizedDescription))")
            }
        }
    }
    
    func testFetchData() {
        remoteDataSource.fetchData(request: .fetchUserProfile(params: FetchUserProfileParam(username: "tawk"))){ result in
            switch result{
                case .success(let user):
                    print("fetchData() -- \(user.username)")
                    
                    XCTAssertNotEqual(user.id, -1)
                    XCTAssertNotEqual(user.username, "")
                    XCTAssertEqual(user.username, "tawk")
                    XCTAssertEqual(user.url, "https://api.github.com/users/tawk")
                    XCTAssertEqual(user.avatarUrl, "https://avatars.githubusercontent.com/u/9743939?v=4")
                case .failure(let error):
                    print("\(String(describing: (error).localizedDescription))")
            }
        }
    }

}
