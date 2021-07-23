//
//  ViewController.swift
//  tawktestios
//
//  Created by JMC on 23/7/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let response = APIClient().send(apiRequest: GithubUserFetchRequest(since: "20"), type: [GithubUser].self).subscribe(onNext: {
            user in
            print("user list = \(user.first?.username)")
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }

}


class GithubUser: Codable {
    var id: Int?
    var username: String?
    
    enum CodingKeys: String, CodingKey {
            case id = "id"
            case username = "login"
        }
}
