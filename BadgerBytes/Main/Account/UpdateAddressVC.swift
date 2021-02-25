//
//  UpdateCardInfo.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/22/21.
//

import Firebase

class UpdateAddressVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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

        self.cv.register(AddressCell.self, forCellWithReuseIdentifier: "SimpleCell")
        self.cv.register(ExpandableAddressCell.self, forCellWithReuseIdentifier: "ExpandableCell")
    }



// everything is public to match public status of protocols they are following
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath == [0, 0]) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCell", for: indexPath) as! AddressCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpandableCell", for: indexPath) as! ExpandableAddressCell
            return cell
        }
        
        //cell.textLabel.text = String(indexPath.row + 1)
    }


    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row == 0) {
            // display address
        } else {
            
        }
        
        
    }


    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (indexPath == [0, 1]) {
            return CGSize(width: collectionView.bounds.size.width - 16, height: 160)
        }
        
        return CGSize(width: collectionView.bounds.size.width - 16, height: 80)
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

/// //// CLASS ////

private class AddressCell: UICollectionViewCell {

    //weak var textLabel: UILabel!
    var margins = UILayoutGuide()
    var ref: DatabaseReference!
    
    func makeAddressInfoFrame() -> UIStackView {
    
        getAddressData()
        let deliveryAddress = UILabel()
        deliveryAddress.text = "Delivery Address: mean street"
        
        let deliveryAddressStreet = UILabel()
        deliveryAddressStreet.text = "Street Name"
        
        let deliveryAddressLoc = UILabel()
        deliveryAddressLoc.text = "Madison, WI, 53705"
        
        let addressInfoFrame = UIStackView()
        addressInfoFrame.axis = .vertical
        
        addressInfoFrame.addArrangedSubview(deliveryAddress)
        addressInfoFrame.addArrangedSubview(deliveryAddressStreet)
        addressInfoFrame.addArrangedSubview(deliveryAddressLoc)
        
        // anchor text to top of cell
        deliveryAddress.translatesAutoresizingMaskIntoConstraints = false
        deliveryAddressStreet.translatesAutoresizingMaskIntoConstraints = false
        deliveryAddressLoc.translatesAutoresizingMaskIntoConstraints = false
        
        // anchor top label
        deliveryAddress.topAnchor.constraint(equalTo: addressInfoFrame.topAnchor).isActive = true
        deliveryAddress.leadingAnchor.constraint(equalTo: addressInfoFrame.leadingAnchor, constant: 10).isActive = true
        deliveryAddress.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // middle label
        deliveryAddressStreet.topAnchor.constraint(equalTo: deliveryAddress.bottomAnchor).isActive = true
        deliveryAddressStreet.leadingAnchor.constraint(equalTo: addressInfoFrame.leadingAnchor, constant: 20).isActive = true
        deliveryAddressStreet.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // bottom label
        deliveryAddressLoc.topAnchor.constraint(equalTo: deliveryAddressStreet.bottomAnchor).isActive = true
        deliveryAddressLoc.leadingAnchor.constraint(equalTo: addressInfoFrame.leadingAnchor, constant: 20).isActive = true
        deliveryAddressLoc.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return addressInfoFrame
    }
    
    func getAddressData() {
        let currentUserID = Auth.auth().currentUser?.uid
        self.ref.child("Users/\(currentUserID!)/username/address/").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
            }
            else {
                print("No data available")
            }
        }
    }

    override init(frame: CGRect) {
        self.ref = Database.database().reference()
        super.init(frame: frame)
        //self.margins = self.contentView.layoutMarginsGuide
        //self.margins = self.contentView.layoutMarginsGuide

        let addressInfoFrame = makeAddressInfoFrame()
        //let textLabel = UILabel(frame: .zero)
        addressInfoFrame.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addressInfoFrame)
        NSLayoutConstraint.activate([
           addressInfoFrame.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            addressInfoFrame.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            addressInfoFrame.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            addressInfoFrame.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        //self.textLabel = textLabel

        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = .card_background
    
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


///  //// CLASS ////

private class ExpandableAddressCell: UICollectionViewCell {
    
    //weak var textLabel: UILabel!
    var margins = UILayoutGuide()
    
    let expandButton = UILabel()
    var addressStack: UIStackView!
    
    var ref: DatabaseReference!
    
    let streetTF: UITextField = {
        let tf = UITextField()
        tf.textColor = .main_label
        tf.tintColor = .main_label
        tf.font = UIFont(regularWithSize: 16)
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let cityTF: UITextField = {
        let tf = UITextField()
        tf.textColor = .main_label
        tf.tintColor = .main_label
        tf.font = UIFont(regularWithSize: 16)
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let stateTF: UITextField = {
        let tf = UITextField()
        tf.textColor = .main_label
        tf.tintColor = .main_label
        tf.font = UIFont(regularWithSize: 16)
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let zipTF: UITextField = {
        let tf = UITextField()
        tf.textColor = .main_label
        tf.tintColor = .main_label
        tf.font = UIFont(regularWithSize: 16)
        tf.keyboardAppearance = .dark
        tf.autocapitalizationType = .none
        return tf
    }()
    
    
    func displayFullStack() -> UIStackView {
        let expandBtn = UILabel()
        expandBtn.text = "Edit Address"
        expandBtn.textAlignment = .center
        expandBtn.adjustsFontSizeToFitWidth = false
        expandBtn.font.withSize(20)
        
        let fullStack = UIStackView()
        fullStack.axis = .vertical
        
        expandBtn.translatesAutoresizingMaskIntoConstraints = false
        
        fullStack.addArrangedSubview(expandBtn)
        
        NSLayoutConstraint.activate([
            expandBtn.topAnchor.constraint(equalTo: fullStack.topAnchor, constant: 10),
            expandBtn.leadingAnchor.constraint(equalTo: fullStack.leadingAnchor),
            expandBtn.heightAnchor.constraint(equalToConstant: 25),
            expandBtn.trailingAnchor.constraint(equalTo: fullStack.trailingAnchor)
        ])
        
        let expandableStack: UIStackView? = displayExpandStack()
    
        if (expandableStack != nil) {
            fullStack.addArrangedSubview(expandableStack!)
            expandableStack!.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                expandableStack!.topAnchor.constraint(equalTo: expandBtn.bottomAnchor),
                expandableStack!.leadingAnchor.constraint(equalTo: fullStack.leadingAnchor),
                expandableStack!.bottomAnchor.constraint(equalTo: fullStack.bottomAnchor),
                expandableStack!.trailingAnchor.constraint(equalTo: fullStack.trailingAnchor)
            ])
            
        }

        
        return fullStack

    }
    
    func displayExpandStack() -> UIStackView? {
        
        let expandableStack = UIStackView()
        expandableStack.axis = .vertical
        
        
        streetTF.attributedPlaceholder = NSAttributedString(string: "Enter new street address", attributes: [.foregroundColor: UIColor.subtitle_label])
        
        cityTF.attributedPlaceholder = NSAttributedString(string: "Enter new city", attributes: [.foregroundColor: UIColor.subtitle_label])
        
        stateTF.attributedPlaceholder = NSAttributedString(string: "Enter new state", attributes: [.foregroundColor: UIColor.subtitle_label])
        
        zipTF.attributedPlaceholder = NSAttributedString(string: "Enter new zipcode", attributes: [.foregroundColor: UIColor.subtitle_label])
        
        let submitBtn: UIButton = {
            let btn = UIButton()
            btn.add(text: "Submit", font: .systemFont(ofSize: 17), textColor: .white)
            btn.addTarget(self, action: #selector(updateAddress), for: .allTouchEvents)
            return btn
        }()
        
        streetTF.translatesAutoresizingMaskIntoConstraints = false
        cityTF.translatesAutoresizingMaskIntoConstraints = false
        stateTF.translatesAutoresizingMaskIntoConstraints = false
        zipTF.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.translatesAutoresizingMaskIntoConstraints = false

        expandableStack.addArrangedSubview(streetTF)
        expandableStack.addArrangedSubview(cityTF)
        expandableStack.addArrangedSubview(stateTF)
        expandableStack.addArrangedSubview(zipTF)
        expandableStack.addArrangedSubview(submitBtn)
        
        NSLayoutConstraint.activate([
            streetTF.topAnchor.constraint(equalTo: expandableStack.topAnchor),
            streetTF.leadingAnchor.constraint(equalTo: expandableStack.leadingAnchor),
            streetTF.trailingAnchor.constraint(equalTo: expandableStack.trailingAnchor),
            
            cityTF.topAnchor.constraint(equalTo: streetTF.bottomAnchor),
            cityTF.leadingAnchor.constraint(equalTo: streetTF.leadingAnchor),
            cityTF.trailingAnchor.constraint(equalTo: streetTF.trailingAnchor),
            
            stateTF.topAnchor.constraint(equalTo: cityTF.bottomAnchor),
            stateTF.leadingAnchor.constraint(equalTo: cityTF.leadingAnchor),
            stateTF.trailingAnchor.constraint(equalTo: cityTF.trailingAnchor),
            
            zipTF.topAnchor.constraint(equalTo: stateTF.bottomAnchor),
            zipTF.leadingAnchor.constraint(equalTo: stateTF.leadingAnchor),
            zipTF.trailingAnchor.constraint(equalTo: stateTF.trailingAnchor),
            
            submitBtn.topAnchor.constraint(equalTo: zipTF.bottomAnchor),
            submitBtn.leadingAnchor.constraint(equalTo: zipTF.leadingAnchor),
            submitBtn.trailingAnchor.constraint(equalTo: zipTF.trailingAnchor),
        ])
        
        return expandableStack
    }
    
    func display() {
        addressStack = displayFullStack()
        //self.margins = self.contentView.layoutMarginsGuide
        //self.margins = self.contentView.layoutMarginsGuide

        //let textLabel = UILabel(frame: .zero)
        addressStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addressStack)
        NSLayoutConstraint.activate([
            addressStack.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            addressStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            addressStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            addressStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        //self.textLabel = textLabel

        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = .card_background
    }

    override init(frame: CGRect) {
        ref = Database.database().reference()
        super.init(frame: frame)
        display()
    }
    
    @objc func updateAddress() {
        
        if (streetTF.text == "" || cityTF.text == "" || stateTF.text == "" || zipTF.text == "") {
            return
        }
        
        let street: String? = streetTF.text
        let city: String? = cityTF.text
        let state: String? = stateTF.text
        let zip: String? = zipTF.text
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        self.ref.child("Users/\(currentUserID)/address/street").setValue(street)
        self.ref.child("Users/\(currentUserID)/address/city").setValue(city)
        self.ref.child("Users/\(currentUserID)/address/state").setValue(state)
        self.ref.child("Users/\(currentUserID)/address/zip").setValue(zip)
        print("Address updated")
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

