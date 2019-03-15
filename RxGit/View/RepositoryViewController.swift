//
//  RepositoryViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 2/17/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryViewController: UIViewController {
    var bag = DisposeBag()
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    var repositoryService: RepositoryService!

    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryService = serviceFactory.newRepositoryService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!, owner: "Taxiway", name: "homepage")
        let model = repositoryService.run().asObservable().share().observeOn(MainScheduler.instance)
        self.view.addSubview(RepositoryView(frame: self.view.frame, model: model))
    }
}
