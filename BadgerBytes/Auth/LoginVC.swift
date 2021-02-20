//
//  LoginVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditing)))
    }
    
    //
    // MARK: Functions
    //
    
    @objc func handleEndEditing() {
        self.view.endEditing(true)
    }
    
    @objc func handleSignUp() {
        let signUpVC = SignUpVC()
        signUpVC.modalPresentationStyle = .overFullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    @objc func handleSignIn() {
        
        guard let email = emailInputView.input.text else {return}
        guard let password = passwordInputView.input.text else {return}

        Auth.auth().signIn(withEmail: email, password: password) { (data, err) in
            if let err = err {
                // TODO: error handling
                print("Sign in error: " + err.localizedDescription)
            }

            print("Successfully signed in user with id: " + (Auth.auth().currentUser?.uid)!)

            let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC

            tabBarVC.setUpViewControllers()
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleForgotPassword() {
        
    }
    
    //
    // MARK: UI Setup
    //
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "auth_background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let containerView = UIView()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "BadgerBytes", font: UIFont(name: "PingFangHK-Regular", size: 45)!, textColor: .subtitle_label)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let inputBackgroundView: UIView = {
        let vw = UIView()
        vw.backgroundColor = .login_input
        vw.alpha = 0.25
        vw.layer.cornerRadius = 8
        return vw
    }()
    
    let emailInputView = AuthInputView(placeholder: "Email", keyboardType: .emailAddress, isPassword: false)
    
    let passwordInputView = AuthInputView(placeholder: "Password", keyboardType: .default, isPassword: true)

    let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.add(text: "Sign in", font: UIFont(boldWithSize: 18), textColor: .subtitle_label)
        btn.layer.borderColor = UIColor.subtitle_label.cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return btn
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Sign up", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.add(text: "Forgot your password? Reset here", font: UIFont(regularWithSize: 14), textColor: .subtitle_label)
        btn.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
                
        self.containerView.addSubviews(views: [titleLabel, inputBackgroundView, emailInputView, passwordInputView, signInButton, signUpButton, forgotPasswordButton])
        self.view.addSubviews(views: [backgroundImageView, containerView])
        
        backgroundImageView.fillSuperview()
        
        containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 489).isActive = true
        containerView.anchorCenterSuperview()
        
        titleLabel.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        
        inputBackgroundView.anchor(titleLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 54, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 314)
        
        emailInputView.anchor(inputBackgroundView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 280, heightConstant: 26)
        emailInputView.anchorCenterXToSuperview()
        
        passwordInputView.anchor(emailInputView.bottomAnchor, left: emailInputView.leftAnchor, bottom: nil, right: emailInputView.rightAnchor, topConstant: 25, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 26)
        
        signInButton.anchor(passwordInputView.bottomAnchor, left: emailInputView.leftAnchor, bottom: nil, right: emailInputView.rightAnchor, topConstant: 43, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        signUpButton.anchor(signInButton.bottomAnchor, left: emailInputView.leftAnchor, bottom: nil, right: emailInputView.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        forgotPasswordButton.anchor(signUpButton.bottomAnchor, left: emailInputView.leftAnchor, bottom: nil, right: emailInputView.rightAnchor, topConstant: 7, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 19)
        
    }
}

