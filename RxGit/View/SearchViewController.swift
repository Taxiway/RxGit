//
//  SearchViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 2/24/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController : UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
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
        searchBar.delegate = self
        collectionView.isPrefetchingEnabled = true
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults?.repositories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepositoryLibraryCollectionViewCell", for: indexPath) as! RepositoryLibraryCollectionViewCell
        cell.nameLabel.text = searchResults?.repositories[indexPath.item].nameWithOwner
        cell.descriptionLabel.text = searchResults?.repositories[indexPath.item].description
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        repositorySearchService = serviceFactory.newRepositorySearchService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!, queryString: searchBar.text)
        repositorySearchService.run()
            .subscribe(onSuccess: { [unowned self] results in
                print(results)
                self.searchResults = results
                self.collectionView.reloadData()
                }, onError: { error in
                    print("Error")
            })
            .disposed(by: self.bag)
    }
}
