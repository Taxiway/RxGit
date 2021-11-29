//
//  SearchViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 2/24/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController : UIViewController {
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    var repositorySearchService: RepositorySearchService!
    var bag = DisposeBag()
    private let searchBar = UISearchBar()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        repositorySearchService = serviceFactory.newRepositorySearchService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!)
        
        let results = searchBar.rx.text.orEmpty
            .throttle(DispatchTimeInterval.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                self.repositorySearchService.run(queryString: query)
                    .asObservable()
                    .flatMap({Observable.from(optional: $0.repositories)})
            }
        
        results.bind(to: collectionView.rx.items(cellIdentifier: "RepositoryLibraryCollectionViewCell", cellType: RepositoryLibraryCollectionViewCell.self)) { (row, element, cell) in
            cell.setRepository(repo: element)
            }.disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRepository2" {
            let cell = sender as! RepositoryLibraryCollectionViewCell
            let repositoryVC = segue.destination as! RepositoryViewController
            repositoryVC.repository = cell.repository
            repositoryVC.navigationItem.title = cell.nameLabel.text
        }
    }
    
}
