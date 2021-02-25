//
//  PaymentCell.swift
//  BadgerBytes
//
//  Created by Connor Hanson on 2/23/21.
//

import UIKit

class PaymentCell: UICollectionViewCell {

    weak var textLabel: UILabel!
    
    let paymentInfoFrame: UIStackView = {
    
        let cardNum = UILabel()
        cardNum.text = "**** **** **** 1234"
        
        let cardType = UILabel()
        cardType.text = "VISA"
        
        let cardHolder = UILabel()
        cardHolder.text = "Card Holder Name"
        
        let connectedToStripe = UILabel()
        connectedToStripe.text = "Stripe Authentication required"
        
        let paymentInfoFrame = UIStackView()
        paymentInfoFrame.axis = .vertical
        
        paymentInfoFrame.addArrangedSubview(cardNum)
        paymentInfoFrame.addArrangedSubview(cardType)
        paymentInfoFrame.addArrangedSubview(cardHolder)
        paymentInfoFrame.addArrangedSubview(connectedToStripe)
        
        return paymentInfoFrame
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
        paymentInfoFrame.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(paymentInfoFrame)
        NSLayoutConstraint.activate([
            paymentInfoFrame.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            paymentInfoFrame.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            paymentInfoFrame.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            paymentInfoFrame.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
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
