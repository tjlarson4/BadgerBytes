//
//  ManageVC.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/18/21.
//

import Firebase

class AccountView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var cv: UICollectionView! // this pages collection view
    
    override func loadView() {
        super.loadView()
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

           self.cv.backgroundColor = .clear
           self.cv.dataSource = self
           self.cv.delegate = self

            self.cv.register(SimpleTextCell.self, forCellWithReuseIdentifier: "Simple")
            //self.cv.register(AddressCell.self, forCellWithReuseIdentifier: "MyCell")
       }



// everything is public to match public status of protocols they are following
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Simple", for: indexPath) as! SimpleTextCell
            //cell.textLabel.text = "Username"
            return cell
        }
        
        if (indexPath.row == 1) {
            // update password
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Simple", for: indexPath) as! SimpleTextCell
            cell.textLabel.text = "Update Password"
            return cell
        }
        
        else if (indexPath.row == 2) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Simple", for: indexPath) as! SimpleTextCell
            cell.textLabel.text = "Update Profile"
            return cell
            // payment info
        }
        
        else if (indexPath.row == 3){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Simple", for: indexPath) as! SimpleTextCell
            cell.textLabel.text = "Update Payment Information"
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Simple", for: indexPath) as! SimpleTextCell
            cell.textLabel.text = "Logout"
            cell.textLabel.textColor = .white
            cell.textLabel.textAlignment = .center
            cell.textLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: -10).isActive = true
            cell.contentView.backgroundColor = .red
            return cell
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        } catch {
            print("Error signing out: " +  error.localizedDescription)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print(indexPath.row + 1)
        
        if (indexPath.row == 0) {
            // update username
        }
        
        if (indexPath.row == 1) {
            let vc = UpdatePasswordVC()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if (indexPath.row == 2) {
            let vc = UpdateAddressVC()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if (indexPath.row == 3) {
            // update payment
        }
            
        // logout
        if (indexPath.row == 4) {
            handleLogout()
        }
        
    }


    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

//        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
            return CGSize(width: collectionView.bounds.size.width - 16, height: 40)
//        } else if (indexPath.row == 1) {
//            return CGSize(width: collectionView.bounds.size.width - 16, height: 80)
//        }
//
//        return CGSize(width: collectionView.bounds.size.width - 16, height: 120)
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



//import UIKit
//class ManageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    let tableView = UITableView()
//    var safeArea: UILayoutGuide!
//
//    var sections = ["Addresses", "Contact Info", "Payments", "Change Password"]
//    var sectionDetails = ["1200 Rue du Pont Levis", "Email: connor@gamil.com\nPhone:123-456-7890", "**** **** **** 1234 VISA"]
//
//    override func loadView() {
//        super.loadView()
//        self.view.backgroundColor = .white
//
//        safeArea = view.layoutMarginsGuide
//        tableView.dataSource = self
//        tableView.delegate = self
//        setupTableView()
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 100
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection: Int) -> UIView? {
//
//            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                       "sectionHeader") as! userHeader
//
//            //view.title.text = sections[viewForHeaderInSection]
//            view.title.text = "COnnor Hanson"
//            view.subTitle.text = "user3456754"
//
//            view.image.image = UIImage(named: "account_icon")
//
//           return view
//    }
//
//    func tableView(_ tableView: UITableView, titleForFooterInSection: Int) -> String? {
//        return "log out"
//    }
//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = sections[indexPath.row]
//        cell.detailTextLabel?.text = sections[indexPath.item]
//        cell.accessoryType = .disclosureIndicator
//        return cell
//    }
//
//    // what happens when a row is selected
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedTrail = sections[indexPath.row]
//        print("selected " + sections[indexPath.row])
//
//        if (indexPath.row == 0) {
//            let vc = UpdateAddressVC()
//            navigationController?.pushViewController(vc, animated: true)
//        }
//
//        else if (indexPath.row == 1) {
//
//        }
//
//        else if (indexPath.row == 2) {
//            let vc = UpdatePaymentVC()
//            navigationController?.pushViewController(vc, animated: true)
//        }
//
//        else if (indexPath.row == 3) {
//
//        }
//
//        else {
//            print("Error navigating menu")
//        }
//
//
//
////        if let viewController = storyboard?.instantiateViewController(identifier: "UpdatePaymentVC") as? UpdatePaymentVC {
////            //viewController.trail = selectedTrail
////            print("yea man")
////            navigationController?.pushViewController(viewController, animated: true)
////        }
//    }
//
//
//    func setupTableView() {
//        tableView.register(userHeader.self,
//               forHeaderFooterViewReuseIdentifier: "sectionHeader")
//
//
//        self.view.addSubview(tableView)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
//        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//
//    }
//}
//
//class userHeader: UITableViewHeaderFooterView {
//        let title = UILabel()
//        let subTitle = UILabel()
//        let image = UIImageView()
//
//        override init(reuseIdentifier: String?) {
//            super.init(reuseIdentifier: reuseIdentifier)
//            configureContents()
//        }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        func configureContents() {
//            image.translatesAutoresizingMaskIntoConstraints = false
//            title.translatesAutoresizingMaskIntoConstraints = false
//            subTitle.translatesAutoresizingMaskIntoConstraints = false
//
//            contentView.addSubview(image)
//            contentView.addSubview(title)
//            contentView.addSubview(subTitle)
//
//            // Center the image vertically and place it near the leading
//            // edge of the view. Constrain its width and height to 50 points.
//            NSLayoutConstraint.activate([
//                image.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
//                image.widthAnchor.constraint(equalToConstant: 50),
//                image.heightAnchor.constraint(equalToConstant: 50),
//                image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//
//                // Center the label vertically, and use it to fill the remaining
//                // space in the header view.
//                title.heightAnchor.constraint(equalToConstant: 30),
//                title.leadingAnchor.constraint(equalTo: image.trailingAnchor,
//                       constant: 40),
//                title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
//                title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
//
//                subTitle.leadingAnchor.constraint(equalTo: image.trailingAnchor,
//                                               constant: 50),
//                subTitle.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
//                subTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 15)
//            ])
//        }
//}

//  override func viewDidLoad() {
//    super.viewDidLoad()
//  }

//
//    let accountPage: UIStackView = {
//
//        // left section
//        let userImg: UIImageView = {
//            let img = UIImage(named: "account_icon")
//
//            let imgView = UIImageView(image: img)
//            imgView.contentMode = .scaleAspectFit
//            return imgView
//        }()
//
//        // right section
//        let userName: UILabel = {
//            let label = UILabel()
//            label.textColor = .black
//            label.textAlignment = .left
//            label.text = ("PlaceHolder User")
//
//            return label
//        }()
//
//        let accountName: UILabel = {
//            let label = UILabel()
//            label.textColor = .black
//            label.textAlignment = .left
//            label.text = ("user7689564")
//
//            return label
//        }()
//
//        // vertical stack containing the username and true name
//        let nameStack = UIStackView()
//        nameStack.axis = .vertical
//        nameStack.addArrangedSubview(userName)
//        nameStack.addArrangedSubview(accountName)
//        nameStack.distribution = .fillEqually
//        nameStack.translatesAutoresizingMaskIntoConstraints = false
//
//        // combine stacks
//        let hStack = UIStackView()
//        hStack.axis = .horizontal
//        hStack.addArrangedSubview(userImg)
//        hStack.addArrangedSubview(nameStack)
//        hStack.translatesAutoresizingMaskIntoConstraints = false
//
//        // set anchors for right side
//        userName.topAnchor.constraint(equalTo: nameStack.topAnchor).isActive = true
//        accountName.bottomAnchor.constraint(equalTo: nameStack.bottomAnchor).isActive = true
//        nameStack.trailingAnchor.constraint(equalTo: hStack.trailingAnchor).isActive = true
//
//        // anchor userImg
//        userImg.topAnchor.constraint(equalTo: hStack.topAnchor).isActive = true
//        userImg.leadingAnchor.constraint(equalTo: hStack.leadingAnchor).isActive = true
//
//        // ... and finally anchor hstack when it is called
//        return hStack
//
//    }()
//
//    let infoStack: UIStackView = {
//
//        let addressStack: UIStackView = {
//            let addressStack = UIStackView()
//
//            let currAddress: UILabel = {
//                let label = UILabel()
//                label.textColor = .black
//                label.textAlignment = .left
//                label.text = ("Address: " + "blah blah placeholder 1234")
//                return label
//            }()
//
//            let updateButton: UIButton = {
//                let btn = UIButton()
//                btn.add(text: "Update Address", font: UIFont(boldWithSize: 17), textColor: .blue)
//                btn.layer.cornerRadius = 5
//
//                // TODO: bring user to update screen
//
//                return btn
//            }()
//
//            addressStack.addArrangedSubview(currAddress)
//            addressStack.addArrangedSubview(updateButton)
//            return addressStack
//        }()
//
//        let phoneStack: UIStackView = {
//            let phoneStack = UIStackView()
//
//            let phoneLabel = UILabel()
//            phoneLabel.text = "Phone Number"
//
//            let phoneNumber = UILabel()
//            phoneNumber.text = "608-776-2323" // God's phone number - go ahead, call it
//
//            let updateBtn = UIButton()
//            updateBtn.add(text: "Update", font: UIFont(boldWithSize: 17), textColor: .blue)
//            updateBtn.layer.cornerRadius = 5
//
//            phoneStack.axis = .vertical
//            phoneStack.addArrangedSubview(phoneLabel)
//            phoneStack.addArrangedSubview(phoneNumber)
//
//            return phoneStack
//        }()
//
//        // users payment info - Card number, ...
//        // can be selected and updated
//        let paymentStack: UIStackView = {
//            let paymentStack = UIStackView()
//
//            let paymentLabel = UILabel()
//            paymentLabel.text = "Payment Info"
//
//            let paymentInfo = SelectedViewCard(index: 0, mainLabel: "**** **** **** 1234",
//                                           subLabels: ["123", "04/20"])
//
//            let paymentInfo2 = SelectedViewCard(index: 1, mainLabel: "**** **** **** 5678",
//                                                subLabels: ["420", "69/69"])
//
//            //paymentStack.spacing = 10
//            paymentStack.axis = .vertical
//            paymentStack.distribution = .fillEqually
//
//            paymentStack.addArrangedSubview(paymentLabel)
//            paymentStack.addArrangedSubview(paymentInfo)
//            paymentStack.addArrangedSubview(paymentInfo2)
//
//
//            paymentLabel.topAnchor.constraint(equalTo: paymentStack.topAnchor).isActive = true
//            paymentInfo.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 0).isActive = true
//            paymentInfo.bottomAnchor.constraint(equalTo: paymentInfo.topAnchor, constant: paymentInfo.frame.height).isActive = false
//            paymentInfo2.topAnchor.constraint(equalTo: paymentInfo.bottomAnchor).isActive = true
//
//            return paymentStack
//        }()
//
//        let updatePassWordBtn: UIButton = {
//            let btn = UIButton()
//            btn.add(text: "Update Password", font: UIFont(boldWithSize: 17), textColor: .blue)
//            btn.layer.cornerRadius = 5
//
//            // TODO
//
//            return btn
//        }()
//
//        let logoutBtn: UIButton = {
//            let btn = UIButton()
//            btn.add(text: "Log out", font: .boldSystemFont(ofSize: 17), textColor: .red)
//            btn.layer.cornerRadius = 5
//
//            return btn
//        }()
//
//
//        let screenStack = UIStackView()
//
//        screenStack.axis = .vertical
//        //screenStack.spacing = 10
//
//        screenStack.addArrangedSubview(addressStack)
//        screenStack.addArrangedSubview(phoneStack)
//        screenStack.addArrangedSubview(paymentStack)
//        screenStack.addArrangedSubview(updatePassWordBtn)
//        screenStack.addArrangedSubview(logoutBtn)
//
//        phoneStack.topAnchor.constraint(equalTo: addressStack.bottomAnchor).isActive = true
//        paymentStack.topAnchor.constraint(equalTo: phoneStack.bottomAnchor).isActive = true
//
//
//        return screenStack
//    }()
//
//
//
//    func setUpViews() {
////        self.view.backgroundColor = .blue
//
////        self.view.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
////        self.view.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
////        self.view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
////        self.view.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
////        self.view.translatesAutoresizingMaskIntoConstraints = false
//
//
//        self.view.addSubview(accountPage)
//        self.view.addSubview(infoStack)
//
//        // anchor entire top section
//        accountPage.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: UIScreen.main.bounds.maxY/10).isActive = true
//        accountPage.centerXAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 2*UIScreen.main.bounds.maxX/7).isActive = true // offset slightly from leading bound (left edge)
//        accountPage.widthAnchor.constraint(equalToConstant: 300).isActive = true
//        accountPage.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        accountPage.translatesAutoresizingMaskIntoConstraints = false
//
//
//        infoStack.topAnchor.constraint(equalTo: accountPage.bottomAnchor, constant: UIScreen.main.bounds.maxY/10).isActive = true
//        infoStack.centerXAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 3*UIScreen.main.bounds.maxX/7).isActive = true // idk bruv magic numbers - literally makes no sense
//        infoStack.widthAnchor.constraint(equalToConstant: 300).isActive = true
////        infoStack.heightAnchor.constraint(equalToConstant: infoStack.).isActive = true
//        infoStack.translatesAutoresizingMaskIntoConstraints = false
//
//
//        // anchor all info relative to top info
////        infoStack.anchor(accountPage.bottomAnchor,
////                            left: self.view.layoutMarginsGuide.leftAnchor,
////                            bottom: self.view.layoutMarginsGuide.bottomAnchor,
////                            right: self.view.layoutMarginsGuide.rightAnchor,
////                            topConstant: UIScreen.main.bounds.maxY/20,
////                            leftConstant: UIScreen.main.bounds.maxX/12,
////                            bottomConstant: 0,
////                            rightConstant: 11 * UIScreen.main.bounds.maxX/12,
////                            widthConstant: 300,
////                            heightConstant: 50)
//        //accountPage.anchorCenterXToSuperview()
////        addressStack.anchorCenterSuperview()
//    }
//
//}
//
//// each SelectedView is a 'card' that is put inside of a vertical stack
//private class SelectedViewCard: UIView {
//
//    private var numSubLabels: Int
//    private var isSelected: Bool
//    private var mainUILabel: UILabel
//    private var subUILabels: [UILabel]
//
//    // don't do more than 4 sublabels
//    public init(index: Int, mainLabel: String, subLabels: [String]) {
//        self.numSubLabels = subLabels.count
//        self.mainUILabel = UILabel()
//        self.mainUILabel.text = mainLabel
//        //self.mainUILabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
//
//        self.isSelected = false
//        self.subUILabels = []
//
//        super.init(frame: .zero)
//
//
//        for i in 0...(subLabels.count - 1) {
//            self.subUILabels.append(UILabel())
//            self.subUILabels[i].text = subLabels[i]
//            //self.subUILabels[i].setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
//        }
//
//        let stack = setUpLabelStack()
//        self.addSubview(stack)
//        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        self.bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
//
//        self.backgroundColor = .green
//
//    }
//
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // add visual elements inside of stack
//    func setUpLabelStack() -> UIStackView {
//
//        let labelStack = UIStackView()
//
//        let subLabelStack: UIStackView = {
//            let subLabelStack = UIStackView()
//            subLabelStack.axis = .horizontal
//            subLabelStack.backgroundColor = .green
////            subLabelStack.distribution = .fill
//            subLabelStack.translatesAutoresizingMaskIntoConstraints = false
//            print("here")
//
//            for label in self.subUILabels {
//                subLabelStack.addArrangedSubview(label)
//                print("im baaaack")
//            }
//
//            return subLabelStack
//        }()
//
//        labelStack.axis = .vertical
//        //labelStack.alignment = .center
//        //labelStack.spacing = 5
//        labelStack.addArrangedSubview(mainUILabel)
//        labelStack.addArrangedSubview(subLabelStack)
//
//
//        return labelStack
//    }
//}
