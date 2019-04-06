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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var bag = DisposeBag()
    let mockData = Observable.just(
        (0..<20).map {
            codePath(hasNextLevel: $0<=10, path: "Path" + "\($0)") }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockData.bind(to: collectionView.rx.items(cellIdentifier: "RepositoryCodePathCell",
                                                  cellType: RepositoryCodePathCell.self)) { (row, element, cell) in
            cell.pathLabel.text = element.path
            if !element.hasNextLevel {
                cell.nextLevel.isHidden = true
            }
        }.disposed(by: bag)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "currentPageChanged"), object: 2)
    }

}
