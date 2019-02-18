//
//  RepositoryLibraryViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift

class RepositoryLibraryViewController: UIViewController, UICollectionViewDataSource {
    private weak var appController : AppController!
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    var repositoryService: RepositoriesService!
    private var repositories: Repositories?
    private var user : User?
    var bag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func reset(_ user: User?) {
        collectionView.isPrefetchingEnabled = true
        repositoryService = serviceFactory.newRepositoriesService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!)
        repositoryService.run()
            .subscribe(onSuccess: { [unowned self] repositories in
                print(repositories)
                self.repositories = repositories
                self.collectionView.reloadData()
                }, onError: { error in
                    print("Error")
            })
            .disposed(by: self.bag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositories?.repositories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepositoryLibraryCollectionViewCell", for: indexPath) as! RepositoryLibraryCollectionViewCell
        cell.nameLabel.text = repositories?.repositories[indexPath.item].name
        cell.descriptionLabel.text = repositories?.repositories[indexPath.item].description
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRepository" {
            let cell = sender as! RepositoryLibraryCollectionViewCell
            let repositoryVC = segue.destination
            repositoryVC.navigationItem.title = cell.nameLabel.text
        }
    }
    
    
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.titleView = searchBar
    }

}
