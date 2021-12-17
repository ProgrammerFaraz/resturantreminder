//
//  LoginViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 07/12/2021.
//

import UIKit
import Presentr

class LoginViewController: UIViewController {

    // MARK: - OUTLETS
    
    // MARK: - VARIABLES
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SETUP VIEW
    
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        Bootstrapper.showHome()
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        let vc = SignUpViewController.initFromStoryboard(name: Constants.Storyboards.authentication)
        let presenter = Presentr.init(presentationType: .custom(width: .fluid(percentage: 1.0),
                                                                height: .fluid(percentage: 0.9), center: .customOrigin(origin: CGPoint.init(x: 0, y: 60))))
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    
    @IBAction func didTapForgotPasswordButton(_ sender: UIButton) {
        let vc = ForgotPasswordViewController.initFromStoryboard(name: Constants.Storyboards.authentication)
        let presenter = Presentr.init(presentationType: .custom(width: .fluid(percentage: 1.0),
                                                                height: .fluid(percentage: 1.0), center: .customOrigin(origin: CGPoint.init(x: 0, y: 40))))
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
    // MARK: - HELPER METHODS
    
}

extension LoginViewController: StoryboardInitializable {}
