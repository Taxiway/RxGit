//
//  RepositoryLibraryViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoryLibraryViewController: UIViewController {
    private weak var appController : AppController!
    let serviceFactory = ServiceFactoryImpl.sharedInstance
    let requestFactory = RequestFactoryImpl.sharedInstance
    var repositoryService: RepositoriesService!
    private var user : User?
    var bag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func reset(_ user: User?) {
        repositoryService = serviceFactory.newRepositoriesService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!)
        _ = repositoryService.run()
            .asObservable()
            .flatMap({Observable.from(optional: $0.repositories)})
            .bind(to: collectionView.rx.items(cellIdentifier: "RepositoryLibraryCollectionViewCell", cellType: RepositoryLibraryCollectionViewCell.self)) { (row, element, cell) in
                cell.setRepository(repo: element)
            }
            .disposed(by: bag)
    }
    
    // trying to use storyBoard's segue in this project, sadly this way we can not use customize init for the controller...
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewRepository1" {
            let cell = sender as! RepositoryLibraryCollectionViewCell
            let repositoryVC = segue.destination as! RepositoryViewController
            repositoryVC.repository = cell.repository
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
