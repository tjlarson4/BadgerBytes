//
//  UpdateCardInfo.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/22/21.
//

import Firebase

class UpdateAddressVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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

           self.cv.backgroundColor = .white
           self.cv.dataSource = self
           self.cv.delegate = self

           self.cv.register(AddressCell.self, forCellWithReuseIdentifier: "MyCell")
       }



// everything is public to match public status of protocols they are following
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! AddressCell
        //cell.textLabel.text = String(indexPath.row + 1)
        return cell
    }


    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print(indexPath.row + 1)
    }


    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width - 16, height: 120)
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

private class AddressCell: UICollectionViewCell {

    weak var textLabel: UILabel!
    
    let addressInfoFrame: UIStackView = {
    
        let deliveryAddress = UILabel()
        deliveryAddress.text = "Delivery Address: mean street"
        
        let addressInfoFrame = UIStackView()
        addressInfoFrame.axis = .vertical
        
        addressInfoFrame.addArrangedSubview(deliveryAddress)
        
        return addressInfoFrame
    }()
    
    // horizontal frame showing a check if it is users currently selected payment
    // other side contains all the info
    let checkFrame: UIStackView = {
        let checkFrame = UIStackView()
        
        
        
        return checkFrame
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        //let textLabel = UILabel(frame: .zero)
        addressInfoFrame.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addressInfoFrame)
        NSLayoutConstraint.activate([
            addressInfoFrame.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            addressInfoFrame.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            addressInfoFrame.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            addressInfoFrame.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        //self.textLabel = textLabel

        self.contentView.backgroundColor = .lightGray
        //self.textLabel.textAlignment = .center
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

        //self.textLabel.text = nil
    }
}

