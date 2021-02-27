//
//  UsageReportView.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/26/21.
//

import UIKit
import Firebase

class UsageReportView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var manageVC: ManageVC?
    
    var usageActions = [UsageItem]()
            
    //
    // MARK: View Lifecycle
    //
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: Functions
    //
    
    func filterSort(_: [UsageItem]) {
        self.usageActions = self.usageActions.sorted { $0.actionDate > $1.actionDate }
    }
    
    func fetchUsageActions() {
        
        usageActions = []
                
        let orderRef = Database.database().reference().child("usage")

        orderRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
                        
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                let usageItem = UsageItem(id: key, dictionary: dictionary)
                
                self.usageActions.append(usageItem)
            })
            
            self.filterSort(self.usageActions)
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    //
    // MARK: CollectionView
    //

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usageActions.count > 0 ? usageActions.count : 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let usageItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "usageItemCell", for: indexPath) as! UsageItemCell
                    
        let usageItem = usageActions[indexPath.row]
        usageItemCell.configure(item: usageItem)

        return usageItemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! UsageHeaderCell
            
            header.titleLabel.text = "All usage actions:"
            header.filterButton.isHidden = false
            
            return header
            
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 40)
    }

    //
    // MARK: UI Setup
    //
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Orders", font: UIFont(name: "PingFangHK-Regular", size: 21)!, textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setUpViews() {
                
        fetchUsageActions()
        
        collectionView.register(UsageItemCell.self, forCellWithReuseIdentifier: "usageItemCell")
        collectionView.register(UsageHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        self.addSubview(collectionView)
        collectionView.fillSuperview()

    }

}

import UIKit

class UsageItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: UsageItem) {
        titleLabel.text = item.actionDate.toStringWith(format: "EEEE, MMM d, h:mm a")
        subtitleTextView.text = "\(item.type) - \(item.desc)"
    }
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Item Title", font: UIFont(regularWithSize: 18), textColor: .black)
        return lbl
    }()
    
    let subtitleTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = UIFont(regularWithSize: 15)
        tv.isScrollEnabled = false
        return tv
    }()

    let separatorView = LineView(color: .lightGray)
    
    func setUpViews() {
        
        self.backgroundColor = .menu_white
        
        self.addSubviews(views: [separatorView, titleLabel, subtitleTextView])
                        
        titleLabel.anchor(self.topAnchor, left: leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 5, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 17)
        
        subtitleTextView.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 5, leftConstant: -5, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 60)
        
        separatorView.anchor(subtitleTextView.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: -5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1.5)
    }
}

class UsageHeaderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "All usage actions", font: UIFont(boldWithSize: 20), textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let filterButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.layer.cornerRadius = 9
        btn.backgroundColor = .subtitle_label
        btn.add(text: "Filter", font: UIFont(boldWithSize: 17), textColor: UIColor(hex: "565656"))
        return btn
    }()
        
    func setUpViews() {
        
        self.backgroundColor = .clear
        
        self.addSubviews(views: [titleLabel])
        
        titleLabel.anchor(nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 17)
        titleLabel.anchorCenterYToSuperview()
        
//        filterButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 7, leftConstant: 0, bottomConstant: 7, rightConstant: 15, widthConstant: 120, heightConstant: 0)
//        filterButton.anchorCenterYToSuperview()

    }
}



