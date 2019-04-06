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
    private weak var appController : AppController!
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    var repositorySearchService: RepositorySearchService!
    private var searchResults: SearchResults?
    private var user : User?
    var bag = DisposeBag()
    private let searchBar = UISearchBar()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        repositorySearchService = serviceFactory.newRepositorySearchService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!)
        
        let results = searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                self.repositorySearchService.run(queryString: query)
                    .asObservable()
                    .flatMap({Observable.from(optional: $0.repositories)})
            }
        
        results.bind(to: collectionView.rx.items(cellIdentifier: "RepositoryLibraryCollectionViewCell", cellType: RepositoryLibraryCollectionViewCell.self)) { (row, element, cell) in
            cell.nameLabel.text = element.name
            cell.descriptionLabel.text = element.description
            }.disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRepository2" {
            let cell = sender as! RepositoryLibraryCollectionViewCell
            let repositoryVC = segue.destination
            repositoryVC.navigationItem.title = cell.nameLabel.text
        }
    }
    
}
