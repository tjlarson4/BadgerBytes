//
//  ManageMenuCategoryView.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/25/21.
//

import UIKit

class ManageMenuCategoryView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var movingViewLeftAnchorContraint: NSLayoutConstraint?
    var manageVC: ManageVC?
    
    //
    // MARK: View Lifecycle
    //
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
        print("reloading")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: Functions
    //
    
    //
    // MARK: Collection View
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! MenuCategoryCell
        
        switch indexPath.row {
        case 0:
            categoryCell.categoryLabel.text = "Burgers"
        case 1:
            categoryCell.categoryLabel.text = "Chicken"
        default:
            categoryCell.categoryLabel.text = "Seafood"
        }

        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width - 2) / 3, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        var category = ""
        switch indexPath.row {
            case 0: category = "burgers"
            case 1: category = "chicken"
            default: category = "seafood"
        }
                            
        manageVC?.filteredMenuItems = manageVC?.menuItems.filter { (menuItem) -> Bool in
            return menuItem.category.lowercased().contains(category)
        } ?? []
        
        manageVC?.filteredMenuItems = manageVC?.filteredMenuItems.sorted { $0.name < $1.name } ?? []

        let itemNum = CGFloat(indexPath.item)
        let x = itemNum * ((UIScreen.main.bounds.width - 2) / 3) + itemNum
        movingViewLeftAnchorContraint?.constant = x

        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
        manageVC?.collectionView.reloadSections(IndexSet(integer: 2))

    }
    
    
    //
    // MARK: UI Setup
    //
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .nav_bar
        return cv
    }()
    
    let movingView: UIView = {
        let vw = UIView()
        vw.backgroundColor = .red
        return vw
    }()
    
    let lineView = LineView(color: .vc_background)

    func setUpViews() {
        
        collectionView.register(MenuCategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        
        self.addSubviews(views: [collectionView, lineView, movingView])
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        movingView.anchor(nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: (UIScreen.main.bounds.width - 3) / 3, heightConstant: 3)
        movingViewLeftAnchorContraint = movingView.leftAnchor.constraint(equalTo: leftAnchor)
        movingViewLeftAnchorContraint?.isActive = true
        
        lineView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 3)
        
    }

}

class ManageMenuCategoryCell: UICollectionViewCell {

    let categoryLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "Burgers", font: UIFont(boldWithSize: 21), textColor: .black)
        lbl.textAlignment = .center
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .menu_white
        self.addSubviews(views: [categoryLabel])
        categoryLabel.anchorCenterSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



