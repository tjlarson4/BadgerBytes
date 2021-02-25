//
//  AccountVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit
import Firebase

class AccountVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
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
            self.cv.register(InformationViewCell.self, forCellWithReuseIdentifier: "Info")
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Info", for: indexPath) as! InformationViewCell
                
                
                let name = "\(globalCurrentUser!.firstName) \(globalCurrentUser!.lastName)"
                let accountType = "\(globalCurrentUser!.accountType) account"
                let address = "Address: \(globalCurrentUser!.address)"
                let phone = "Phone: \(globalCurrentUser!.phoneNum)"
                let email = "Email: \(globalCurrentUser!.email)"
                
                
                cell.addLabelInOrder(label: name, isBold: true, size: 2)
                cell.addLabelInOrder(label: accountType, isBold: false, size: 1)
                cell.addLabelInOrder(label: address, isBold: false, size: 1)
                cell.addLabelInOrder(label: phone, isBold: false, size: 1)
                cell.addLabelInOrder(label: email, isBold: false, size: 1)
                
                
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
                cell.textLabel.text = "Update Address"
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
                let vc = ModifyAccount()
                navigationController?.pushViewController(vc, animated: true)
            }
            
            if (indexPath.row == 3) {
                let vc = UpdatePaymentVC()
                navigationController?.pushViewController(vc, animated: true)
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

            if (indexPath.row == 0) {
                return CGSize(width: collectionView.bounds.size.width - 16, height: 120)
            }
                return CGSize(width: collectionView.bounds.size.width - 16, height: 40)

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
