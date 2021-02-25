//
//  SignUpVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//
import UIKit
import Firebase

class ModifyAccount:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var cv: UICollectionView! // this pages collection view
    var cellExpanded: Bool!
    
    override func loadView() {
        super.loadView()
        
        cellExpanded = false
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cv)
        
        NSLayoutConstraint.activate([
                   cv.topAnchor.constraint(equalTo: self.view.topAnchor),
                   cv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                   cv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                   cv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
               ])
        self.cv = cv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cv.backgroundColor = .gray
        self.cv.dataSource = self
        self.cv.delegate = self

        self.cv.register(SimpleTextInputCell.self, forCellWithReuseIdentifier: "InputCell")
        self.cv.register(SimpleTextCell.self, forCellWithReuseIdentifier: "TextCell")
    }



// everything is public to match public status of protocols they are following
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let placeHolders = ["First Name", "Last Name", "Address", "Email", "Phone Number"]
        
        if (indexPath.row == 5) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! SimpleTextCell
            cell.textLabel.text = "Submit"
            cell.textLabel.textColor = .white
            cell.textLabel.textAlignment = .center
            cell.textLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: -10).isActive = true
            cell.contentView.backgroundColor = .red
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputCell", for: indexPath) as! SimpleTextInputCell
            
            cell.textInput.attributedPlaceholder = NSAttributedString(string: placeHolders[indexPath.row], attributes: [.foregroundColor: UIColor.subtitle_label])
            
            return cell
        }
        
        //cell.textLabel.text = String(indexPath.row + 1)
    }


    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row == 5) {
            saveItems()
            
            // reset UI
            let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
            tabBarVC.setUpViewControllers()
            self.view.endEditing(true)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func saveItems() {
        let firstName = (self.cv.cellForItem(at: [0,0]) as! SimpleTextInputCell).textInput.text
        let lastName = (self.cv.cellForItem(at: [0,1]) as! SimpleTextInputCell).textInput.text
        let address = (self.cv.cellForItem(at: [0,2]) as! SimpleTextInputCell).textInput.text
        let email = (self.cv.cellForItem(at: [0,3]) as! SimpleTextInputCell).textInput.text
        let phone = (self.cv.cellForItem(at: [0,4]) as! SimpleTextInputCell).textInput.text
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        let values = ["firstName": firstName!, "lastName": lastName!, "email": email!, "phoneNum":phone!, "address": address!, "accountType": globalCurrentUser?.accountType]
        

        Database.database().reference().child("Users").child(currentUserID).updateChildValues(values)
        
        Auth.auth().currentUser?.updateEmail(to: email!, completion: { (err) in
            if let err = err {
                print("Database info error: " + err.localizedDescription)
            }

            print("Successfully updated email")
        })
    }


    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width - 16, height: 50)
    }
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
    
//    override func viewDidLoad() {
//        setUpViews()
//        fillInfo()
//    }
//
//    @objc func handleDismiss() {
//        self.view.endEditing(true)
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func fillInfo(){
//        emailInputView.input.text = globalCurrentUser?.email
//        phoneNumInputView.input.text = globalCurrentUser?.phoneNum
//        addressInputView.input.text = globalCurrentUser?.address
//    }
//
//    func resetUI() {
//        let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
//        tabBarVC.setUpViewControllers()
//        self.view.endEditing(true)
//        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//    }
//
//    @objc func saveChanges() {
//
//        guard let email = emailInputView.input.text else {return}
//        guard let password = passwordInputView.input.text else {return}
//        guard let phoneNum = phoneNumInputView.input.text else {return}
//        guard let address = addressInputView.input.text else {return}
//
//            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
//            let values = ["firstName": globalCurrentUser?.firstName, "lastName": globalCurrentUser?.lastName, "email": email, "phoneNum":phoneNum, "address":address,"accountType":"admin"]
//
//            Database.database().reference().child("Users").child(currentUserID).updateChildValues(values)
//
//                print("Successfully stored user info")
//        Auth.auth().currentUser?.updateEmail(to: email, completion: { (err) in
//            if let err = err {
//                print("Database info error: " + err.localizedDescription)
//            }
//
//            print("Successfully updated email")
//        })
//
//        let hasPassword = passwordInputView.input.text?.isEmpty
//        if !hasPassword! {
//            Auth.auth().currentUser?.updatePassword(to: passwordInputView.input.text!, completion: { (err) in
//                if let err = err {
//                    print("Database info error: " + err.localizedDescription)
//                }
//
//                print("Successfully updated password")
//            })
//        }
//
//                let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
//
//                tabBarVC.setUpViewControllers()
//                self.view.endEditing(true)
//                self.dismiss(animated: true, completion: nil)
//
//
//
//
//            self.resetUI()
//
//
//    }
//
//    let backgroundImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(named: "auth_background")
//        iv.contentMode = .scaleAspectFill
//        iv.alpha = 0.6
//        return iv
//    }()
//
//    let containerView = UIView()
//
//    let dismissButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setImage(UIImage(named: "dismiss_btn")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
//        return btn
//    }()
//
//    let inputBackgroundView: UIView = {
//        let vw = UIView()
//        vw.backgroundColor = .login_input
//        vw.alpha = 0.25
//        vw.layer.cornerRadius = 8
//        return vw
//    }()
//
//    let phoneNumInputView = AuthInputView(placeholder: "Phone Number", keyboardType: .numberPad, isPassword: false)
//    let addressInputView = AuthInputView(placeholder: "Address", keyboardType: .namePhonePad, isPassword: false)
//    let emailInputView = AuthInputView(placeholder: "Email", keyboardType: .emailAddress, isPassword: false)
//    let passwordInputView = AuthInputView(placeholder: "Leave Blank for same Password", keyboardType: .default, isPassword: true)
//
//    lazy var inputStackView: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [phoneNumInputView,addressInputView, emailInputView, passwordInputView])
//        sv.axis = .vertical
//        sv.distribution = .equalSpacing
//        return sv
//    }()
//
//    let modifyButton: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.layer.cornerRadius = 9
//        btn.backgroundColor = .subtitle_label
//        btn.add(text: "Save Changes", font: UIFont(boldWithSize: 18), textColor: UIColor(hex: "565656"))
//        btn.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
//        return btn
//    }()
//
//    func setUpViews() {
//
//        self.view.backgroundColor = .black
//
//        self.containerView.addSubviews(views: [dismissButton, inputBackgroundView, inputStackView, modifyButton])
//        self.view.addSubviews(views: [backgroundImageView, containerView])
//
//        backgroundImageView.fillSuperview()
//
//        containerView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 30, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 380)
//
//        dismissButton.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
//
//        inputBackgroundView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 75, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//
//        inputStackView.anchor(inputBackgroundView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 25, leftConstant: 25, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 170)
//
//        modifyButton.anchor(inputStackView.bottomAnchor, left: inputStackView.leftAnchor, bottom: nil, right: inputStackView.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
//
//    }
//}
