//
//  RepositoryCodeViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 3/18/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct codePath {
    var hasNextLevel: Bool
    var path: String
}

class RepositoryCodeViewController: UIViewController {
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    var repositoryFilesService: RepositoriesFilesService!
    var repository: Repository?
    private var queryString: String = ""
    var bag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryFilesService = serviceFactory.newRepositoryFilesService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!, owner: repository!.owner, name: repository!.name)
        _ = repositoryFilesService.run(queryString: queryString)
            .asObservable()
            .flatMap({Observable.from(optional: $0.files)})
            .bind(to: collectionView.rx.items(cellIdentifier: "RepositoryCodePathCell", cellType: RepositoryCodePathCell.self)) { (row, element, cell) in
                cell.pathLabel.text = element.name
                cell.nextLevel.isHidden = !(element.type == "tree" && !element.name.contains("."))
            }
            .disposed(by: bag)
        
        // collectionView itemSelected -> update queryString (subscribe)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "currentPageChanged"), object: 2)
    }

}
