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
    var queryString: String = ""
    var bag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryFilesService = serviceFactory.newRepositoryFilesService(requestFactory: requestFactory, userTokenManager: requestFactory.userTokenManager!, owner: repository!.owner, name: repository!.name)
        _ = repositoryFilesService.run(queryString: queryString)
            .asObservable()
            .flatMap({Observable.from(optional: $0.files)})
            .bind(to: collectionView.rx.items(cellIdentifier: "RepositoryCodePathCell", cellType: RepositoryCodePathCell.self)) { (row, element, cell) in
                self.setCell(cell, withFile: element)
            }
            .disposed(by: bag)
    }
    
    // trying to use storyBoard's segue in this project, sadly this way we can not use customize init for the controller...
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codeFile" {
            let cell = sender as! RepositoryCodePathCell
            let repositoryVC = segue.destination as! RepositoryCodeViewController
            repositoryVC.repository = repository
            if let name = cell.pathLabel.text {
                repositoryVC.queryString = queryString + name + "/"
            }
        }
    }
    
    func setCell(_ cell: RepositoryCodePathCell, withFile file: File) {
        cell.pathLabel.text = file.name
        cell.icon.contentMode = .scaleAspectFit
        if file.type == "tree" && !file.name.contains(".") {
            cell.icon.image = UIImage.init(named: "file-directory")
            cell.nextLevel.isHidden = false
        } else {
            cell.icon.image = UIImage.init(named: "file-text")
            cell.nextLevel.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "currentPageChanged"), object: 2)
    }

}
