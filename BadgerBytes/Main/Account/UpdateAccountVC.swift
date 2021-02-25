//
//  UpdateCardInfo.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/22/21.
//

import Firebase

class UpdateAccountVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var cv: UICollectionView! // this pages collection view
    var cellExpanded: Bool!
    
    var textPlaceHolders: [String]!
    
    override func loadView() {
        super.loadView()
        
        textPlaceHolders = ["Update address", "Update Phone", "Update email"]
        
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

//        self.cv.register(AddrressCell.self, forCellWithReuseIdentifier: "SimpleCell")
        self.cv.register(SimpleTextInputCell.self, forCellWithReuseIdentifier: "InputCell")
//        self.cv.register(ExpandableAddressCell.self, forCellWithReuseIdentifier: "ExpandableCell")
        self.cv.register(SimpleTextCell.self, forCellWithReuseIdentifier: "ExitCell")
    }



// everything is public to match public status of protocols they are following
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        if (indexPath == [0,3]){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExitCell", for: indexPath) as! SimpleTextCell
            cell.textLabel.text = "Submit"
            cell.textLabel.textColor = .white
            cell.textLabel.textAlignment = .center
            cell.textLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: -10).isActive = true
            cell.contentView.backgroundColor = .red
            return cell
        }
            
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputCell", for: indexPath) as! SimpleTextInputCell
            cell.textInput.attributedPlaceholder = NSAttributedString(string: textPlaceHolders[indexPath.row], attributes: [.foregroundColor: UIColor.subtitle_label])
            return cell
        }
        
        //cell.textLabel.text = String(indexPath.row + 1)
    }


    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            // display address
        } else if (indexPath.row == 3){
            saveChanges()
            let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
            tabBarVC.setUpViewControllers()
            self.view.endEditing(true)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            //self.resetUI()
        }
        
    }
    
    public func saveChanges() {
        guard let email = (self.cv.cellForItem(at: [0,2]) as! SimpleTextInputCell).textInput.text else {return}
        guard var phoneNum = (self.cv.cellForItem(at: [0,1]) as! SimpleTextInputCell).textInput.text else {return}
        guard var address = (self.cv.cellForItem(at: [0,0]) as! SimpleTextInputCell).textInput.text else {return}
            
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        if (phoneNum == "") {
            phoneNum = globalCurrentUser?.phoneNum as! String
        }
        
        if (address == "") {
            address = globalCurrentUser?.address as! String
        }
        
        let values = ["firstName": globalCurrentUser?.firstName, "lastName": globalCurrentUser?.lastName, "email": email, "phoneNum":phoneNum, "address":address,"accountType":"admin"]
        
        Database.database().reference().child("Users").child(currentUserID).updateChildValues(values)

        if (email != "") {
            print("Successfully stored user info")
            Auth.auth().currentUser?.updateEmail(to: email, completion: { (err) in
                if let err = err {
                    print("Database info error: " + err.localizedDescription)
                }
                print("Successfully updated email")
            })
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

//        if (indexPath == [0, 1]) {
//            return CGSize(width: collectionView.bounds.size.width - 16, height: 160)
//        }
        
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
