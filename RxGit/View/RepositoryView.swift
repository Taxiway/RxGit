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
    var percentLabels: [UILabel]
    var languages: Variable<Languages>
    var bag = DisposeBag()

    override init(frame: CGRect) {
        nameLabels = [UILabel]()
        percentBars = [UIView]()
        percentLabels = [UILabel]()
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
        for label in percentLabels {
            label.removeFromSuperview()
        }
        nameLabels = [UILabel]()
        percentBars = [UIView]()
        percentLabels = [UILabel]()
    }

    func createBarView(_ percent: CGFloat) -> UIView {
        return UIView(frame: CGRect(x: 60, y: 0, width: floor(percent * (self.frame.width - 120)), height: 30))
    }

    func animateBarView(_ barView: UIView) {
        let width = barView.frame.size.width
        barView.frame.size.width = 0
        UIView.animate(withDuration: 1.0, animations: {
            barView.frame.size.width = width
        })
    }

    func createViews(_ languages: Languages) {
        var y: CGFloat = 0.0
        var index = 0
        for language in languages.languages {
            let name = UILabel(frame: CGRect(x: 0, y: y, width: 60, height: 30))
            nameLabels.append(name)
            name.text = language.name
            addSubview(name)
            let p = CGFloat(languages.sizes[index]) / CGFloat(languages.totalSize)
            let bar = createBarView(p)
            bar.frame.origin.y = y
            bar.backgroundColor = UIColor.colorWithHexString(hex: language.color)
            animateBarView(bar)
            percentBars.append(bar)
            addSubview(bar)
            let percent = UILabel(frame: CGRect(x: self.frame.width - 60, y: y, width: 60, height: 30))
            percentBars.append(percent)
            percent.text = String(format: "%.2lf%%", p * 100.0)
            addSubview(percent)
            y += 40.0
            index += 1
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

extension UIColor {
    class func colorWithHexString(hex:String) -> UIColor {
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
