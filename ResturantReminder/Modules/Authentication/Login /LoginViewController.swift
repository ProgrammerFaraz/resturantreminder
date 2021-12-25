//
//  LoginViewController.swift
//  ResturantReminder
//
//  Created by Mehdi Haider on 07/12/2021.
//

import UIKit
import Presentr
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    // MARK: - VARIABLES
    var viewModel = LoginViewModel()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectFields()
    }
    
    // MARK: - SETUP VIEW
    private func connectFields() {
        UITextField.connectFields(fields: [self.textFieldEmail, self.textFieldPassword])
    }
    
    // MARK: - BUTTON ACTIONS
    
    @IBAction func didTapShowHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.textFieldPassword.isSecureTextEntry = sender.isSelected
    }
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        UIApplication.startActivityIndicator(with: "Logging in..")
        viewModel.loginUser(email: self.textFieldEmail.text ?? "", password: self.textFieldPassword.text ?? "") { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let error = error {
                UIApplication.stopActivityIndicator()
                Snackbar.showSnackbar(message: error.localizedDescription, duration: .middle)
                return
            } else {
                FirebaseManager.shared.fetchUser(userID: authResult?.user.uid ?? "") { error  in
                    if let error = error {
                        UIApplication.stopActivityIndicator()
                        Snackbar.showSnackbar(message: error, duration: .middle)
                        return
                    } else {
                        UIApplication.stopActivityIndicator()
                        AppDefaults.currentUser = UserModel.shared
                        AppDefaults.isUserLoggedIn = true
                        Bootstrapper.showHome()
                    }
                }
//                print("Auth Result: \(authResult)")
//                Bootstrapper.showHome()
            }
        }
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
    
    
    @IBAction func facebookLoginTapped(_ sender: UIButton) {
        //        Authentication.sharedInstance().facebookLogin(fromVC: self) { [weak self] (userId, accessToken, check) in
        //
        //        }
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
            }
        }
    }
    
    @IBAction func gmailLoginTapped(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: Constants.googleClientID)
        
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self
        ) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            // Your user is signed in!
        }
    }
    
    // MARK: - HELPER METHODS
    
}

extension LoginViewController: StoryboardInitializable {}
