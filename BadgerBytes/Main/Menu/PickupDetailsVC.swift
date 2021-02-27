//
//  PickupDetailsVC.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/25/21.
//

import Foundation
import Firebase
import UIKit

class PickupDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cv: UICollectionView!
    
    @objc func handleDismiss() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
        // reset UI
        let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! TabBarVC
        tabBarVC.setUpViewControllers()
        self.view.endEditing(true)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == 0) {
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "PickupCar", for: indexPath) as! SimpleTextInputCell
            cell.textInput.attributedPlaceholder = NSAttributedString(string: "Tap to add a car description", attributes: [.foregroundColor: UIColor.white])
            return cell
        } else if (indexPath.row == 1){
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "PickupTime", for: indexPath) as! PickupTimeCell
            return cell
        } else {
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "Submit", for: indexPath) as! SimpleTextCell
            cell.textLabel.text = "Submit"
            cell.textLabel.textColor = .white
            cell.textLabel.textAlignment = .center
            cell.textLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: -10).isActive = true
            cell.contentView.backgroundColor = .cred
            return cell
        }
    }
    
    // did select
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row == 2) {
            
            handleSubmit()
//            handleDismiss()
            
        }
            
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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
    
    private func handleSubmit() {

        let parentVC = self.presentingViewController as! CartOrderVC
        
        var car = (self.cv.cellForItem(at: [0,0]) as! SimpleTextInputCell).textInput.text
        if (car == ""){car = "Empty"}
        
        let pickupTime = (self.cv.cellForItem(at: [0,1]) as! PickupTimeCell).datePicker.date
            
        let values = ["carDesc": car!, "pickupDate": pickupTime.timeIntervalSince1970] as [String : Any]
        
        parentVC.ref.updateChildValues(values)
        
        parentVC.ref.updateChildValues(values) { (err, ref) in
            parentVC.placeOrderCallback?()
        }
        
    }

    func setUpViews() {
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
                   cv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                   cv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                   cv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
               ])
        self.cv = cv
        
        self.cv.dataSource = self
        self.cv.delegate = self
        self.cv.backgroundColor = .menu_white
        self.cv.layer.cornerRadius = 10
        
        self.cv.register(SimpleTextInputCell.self, forCellWithReuseIdentifier: "PickupCar")
        self.cv.register(PickupTimeCell.self, forCellWithReuseIdentifier: "PickupTime")
        self.cv.register(SimpleTextCell.self, forCellWithReuseIdentifier: "Submit")
    }
    
}

private class PickupTimeCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.contentView.addSubview(datePicker)
        
        datePicker.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = .gray
        datePicker.tintColor = .white
    }
    
    let datePicker = UIDatePicker()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
