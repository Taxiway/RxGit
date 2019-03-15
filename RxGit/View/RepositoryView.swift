//
//  RepositoryView.swift
//  RxGit
//
//  Created by Hang on 3/11/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguagesView: UIView {
    var nameLabels: [UILabel]
    var percentBars: [UIView]
    var languages: Variable<Languages>
    var bag = DisposeBag()

    override init(frame: CGRect) {
        nameLabels = [UILabel]()
        percentBars = [UIView]()
        languages = Variable(Languages())
        super.init(frame: frame)
        languages
            .asObservable()
            .subscribe(onNext: { [weak self] languages in
                self?.dataLoaded(languages)
            })
            .disposed(by: bag)
    }

    func dataLoaded(_ languages: Languages) {
        DispatchQueue.main.async {
            self.clearViews()
            self.createViews(languages)
        }
    }

    func clearViews() {
        for label in nameLabels {
            label.removeFromSuperview()
        }
        for bar in percentBars {
            bar.removeFromSuperview()
        }
        nameLabels = [UILabel]()
        percentBars = [UIView]()
    }

    func createViews(_ languages: Languages) {
        for _ in languages.languages {
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RepositoryView: UIView {
    var nameLabel: UILabel!
    var languagesLabel: UILabel!
    var languagesView: LanguagesView!
    var dataModel: Observable<Repository>
    var bag = DisposeBag()
    var loadingView: UIActivityIndicatorView!

    init(frame: CGRect, model: Observable<Repository>) {
        dataModel = model
        super.init(frame: frame)
        setupViews()
        dataModel
            .subscribe(onNext: { [weak self] _ in
                self?.dataLoaded()
            })
            .disposed(by: bag)
        dataModel.map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: bag)
        dataModel.map { $0.languages }
            .subscribe(onNext: { [weak self] languages in
                self?.languagesView.languages.value = languages
            })
            .disposed(by: bag)
    }

    func dataLoaded() {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.loadingView.isHidden = true
            self.nameLabel.isHidden = false
            self.languagesLabel.isHidden = false
            self.languagesView.isHidden = false
        }
    }

    func setupViews() {
        loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.frame = CGRect(x: 50, y: 100, width: self.frame.size.width - 100, height: 50)
        loadingView.startAnimating()
        self.addSubview(loadingView)
        
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.frame = CGRect(x: 50, y: 100, width: self.frame.size.width - 100, height: 50)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.isHidden = true
        self.addSubview(nameLabel)

        languagesLabel = UILabel()
        languagesLabel.text = "Languages"
        languagesLabel.frame = CGRect(x: 50, y: 200, width: self.frame.size.width - 100, height: 50)
        languagesLabel.adjustsFontSizeToFitWidth = true
        languagesLabel.textAlignment = .center
        languagesLabel.isHidden = true
        self.addSubview(languagesLabel)
    
        languagesView = LanguagesView(frame: CGRect(x: 50, y: 300, width: self.frame.size.width - 100, height: 300))
        languagesView.isHidden = true
        self.addSubview(languagesView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
