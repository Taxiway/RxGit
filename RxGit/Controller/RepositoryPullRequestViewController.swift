//
//  RepositoryPullRequestViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 3/18/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class RepositoryPullRequestViewController: UIViewController {
    var repository: Repository?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "currentPageChanged"), object: 1)
    }

}
