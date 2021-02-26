//
//  SignUpVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    var accountType: String?
    
    override func viewDidLoad() {
        setUpViews()
        firstNameInputView.input.becomeFirstResponder()
    }
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetUI() {
        let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
        tabBarVC.setUpViewControllers()
        self.view.endEditing(true)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignUp() {
        
        guard let email = emailInputView.input.text else {return}
        guard let password = passwordInputView.input.text else {return}
        guard let firstName = firstNameInputView.input.text else {return}
        guard let lastName = lastNameInputView.input.text else {return}
        guard let phoneNum = phoneNumInputView.input.text else {return}
        guard let address = addressInputView.input.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (data, err) in
            if let err = err {
                print("Registration error: " + err.localizedDescription)
            }

            if (Auth.auth().currentUser?.uid != nil){
                print("Successfully created user with id: " + (Auth.auth().currentUser?.uid)!)
            } else {
                let alert = UIAlertController(title: "Error!", message: "Fill out all of the boxes before creating an account.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 4
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            
            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
            let values = ["firstName": firstName, "lastName": lastName, "email": email, "phoneNum":phoneNum, "address":address,"accountType":self.accountType]
            
            Database.database().reference().child("Users").child(currentUserID).setValue(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Database info error: " + err.localizedDescription)
                }

                print("Successfully stored user info")
                
                Database.uploadUsageAction(usageItem: UsageItem(type: .userSignUP, desc: "User: \"\(firstName) \(lastName)\" signed up for BadgerBytes", actingUserID: currentUserID))
                
            })
            
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
            
            
            
            self.resetUI()
        }
        
    }
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "auth_background")
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.6
        return iv
    }()
    
    let containerView = UIView()
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    let inputBackgroundView: UIView = {
        let vw = UIView()
        vw.backgroundColor = .login_input
        vw.alpha = 0.25
        vw.layer.cornerRadius = 8
        return vw
    }()
    
    let firstNameInputView = AuthInputView(placeholder: "First name", keyboardType: .namePhonePad, isPassword: false)
    let lastNameInputView = AuthInputView(placeholder: "Last name", keyboardType: .namePhonePad, isPassword: false)
    let phoneNumInputView = AuthInputView(placeholder: "Phone Number", keyboardType: .numberPad, isPassword: false)
    let addressInputView = AuthInputView(placeholder: "Address", keyboardType: .namePhonePad, isPassword: false)
    let emailInputView = AuthInputView(placeholder: "Email", keyboardType: .emailAddress, isPassword: false)
    let passwordInputView = AuthInputView(placeholder: "Password", keyboardType: .default, isPassword: true)
    
    lazy var inputStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [firstNameInputView, lastNameInputView,phoneNumInputView,addressInputView, emailInputView, passwordInputView])
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        return sv
    }()
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Sign up", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
    }()
    
    func setUpViews() {
        
        self.view.backgroundColor = .black
        
        self.containerView.addSubviews(views: [dismissButton, inputBackgroundView, inputStackView, signUpButton])
        self.view.addSubviews(views: [backgroundImageView, containerView])
        
        backgroundImageView.fillSuperview()
        
        containerView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 380)
        
        dismissButton.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
                
        inputBackgroundView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 75, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        inputStackView.anchor(inputBackgroundView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 25, leftConstant: 25, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 170)
        
        signUpButton.anchor(inputStackView.bottomAnchor, left: inputStackView.leftAnchor, bottom: nil, right: inputStackView.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    
    }
}

