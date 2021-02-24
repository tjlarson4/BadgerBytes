//
//  MenuCategoryView.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/23/21.
//

import UIKit

class MenuCategoryView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var movingViewLeftAnchorContraint: NSLayoutConstraint?
    
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
    
    //
    // MARK: Collection View
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! MenuCategoryCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.width - 3) / 3, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: Record index pressed, filter OR scroll to spot on menu based on category selected
        
        // TODO: Populate purple collection view with menu items, make into array of menu items so it is searchable
        
        let itemNum = CGFloat(indexPath.item)
        let x = itemNum * ((UIScreen.main.bounds.width - 3) / 3) + itemNum
        movingViewLeftAnchorContraint?.constant = x

        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! MenuCategoryCell
//        cell.categoryView.backgroundColor = .blue
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
        vw.backgroundColor = .spotify
        return vw
    }()
    
    func setUpViews() {
        
        collectionView.register(MenuCategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        
        self.addSubviews(views: [collectionView, movingView])
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        movingView.anchor(nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: (UIScreen.main.bounds.width - 3) / 3, heightConstant: 2.5)
        movingViewLeftAnchorContraint = movingView.leftAnchor.constraint(equalTo: leftAnchor)
        movingViewLeftAnchorContraint?.isActive = true
        
    }

}

class MenuCategoryCell: UICollectionViewCell {

    let categoryView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .blue
        self.addSubviews(views: [categoryView])
        categoryView.anchorCenterSuperview()    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
