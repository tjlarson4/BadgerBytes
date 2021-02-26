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
            cell.textInput.attributedPlaceholder = NSAttributedString(string: "Briefly describe your pickup vehicle", attributes: [.foregroundColor: UIColor.subtitle_label])
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
            cell.contentView.backgroundColor = .red
            return cell
        }
    }
    
    // did select
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row == 2) {
            
            handleSubmit()
            handleDismiss()
            
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
        if (car == ""){car = "bruh you gotta put your car in next time. how will are we supposed to find you?"}
        
        let time = (self.cv.cellForItem(at: [0,1]) as! PickupTimeCell).datePicker.date.description
        
        let values = ["car": car!, "date": time]
        
        parentVC.ref.updateChildValues(values)
        
        print("set")
    }

    func setUpViews() {
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cv)
        
        NSLayoutConstraint.activate([
                   cv.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150),
                   cv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                   cv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                   cv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
               ])
        self.cv = cv
        
        self.cv.dataSource = self
        self.cv.delegate = self
        self.cv.backgroundColor = .gray
        self.cv.layer.cornerRadius = 5
        
        self.cv.register(SimpleTextInputCell.self, forCellWithReuseIdentifier: "PickupCar")
        self.cv.register(PickupTimeCell.self, forCellWithReuseIdentifier: "PickupTime")
        self.cv.register(SimpleTextCell.self, forCellWithReuseIdentifier: "Submit")
    }
    
}

private class PickupTimeCell: UICollectionViewCell {
    var datePicker: UIDatePicker!

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.datePicker = UIDatePicker()
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = .card_background
    }

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
