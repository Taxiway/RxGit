//
//  LoginViewController.swift
//  RxGit
//
//  Created by Luo, Yaoxiang on 1/20/19.
//  Copyright © 2019 RxGit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private weak var appController : AppController?
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    
    static func make(_ appController : AppController?) -> LoginViewController? {
        let controller = UIStoryboard(
            name: "Login",
            bundle: Bundle(for: AppDelegate.self))
            .instantiateInitialViewController() as? LoginViewController
        controller?.appController = appController
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activeIndicator.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignInButton(_ sender: Any) {
        appController?.enterLibrary()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
