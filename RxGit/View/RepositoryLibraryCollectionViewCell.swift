//
//  RepositoryLibraryCollectionViewCell.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class RepositoryLibraryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var repository: Repository?
    
    func setRepository(repo: Repository) {
        nameLabel.text = repo.name
        descriptionLabel.text = repo.description
        repository = repo
    }
}
