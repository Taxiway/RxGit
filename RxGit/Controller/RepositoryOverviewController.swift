//
//  RepositoryOverviewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 3/18/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RepositoryOverviewController: UIViewController {
    var bag = DisposeBag()
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    var repositoryService: RepositoryService!
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryService = serviceFactory.newRepositoryService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!, owner: repository!.owner, name: repository!.name)
        let model = repositoryService.run().asObservable().share().observeOn(MainScheduler.instance)
        self.view.addSubview(RepositoryView(frame: self.view.frame, model: model))
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "currentPageChanged"), object: 0)
    }

}
