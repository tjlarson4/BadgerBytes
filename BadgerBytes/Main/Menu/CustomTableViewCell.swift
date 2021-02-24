//
//  CustomTableViewCell.swift
//  MenuProgrammatically
//
//  Created by Atessa Amjadi on 2/21/21.
//

import UIKit

//source: https://www.youtube.com/watch?v=Pu7B7uEzP18

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
//    private let _switch: UISwitch = {
//        let _switch = UISwitch()
//        _switch.onTintColor = .green
//        _switch.isOn = true
//        return _switch
//    }()
    
   
    private let startButton: UIButton = {
        let startButton = UIButton(type: .system)
        startButton.setTitle(">", for: .normal)
        return startButton
    }()
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "Chicken tacos")
        imageView.contentMode = .scaleAspectFill
        
        //make sure image does not exceed bounds of cell
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        //label.text = "Custom Menu Label"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) { super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
//        contentView.addSubview(_switch)
        contentView.addSubview(startButton)
        contentView.addSubview(myLabel)
        contentView.addSubview(myImageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(text: String, imageName: String) {
        myLabel.text = text
        myImageView.image = UIImage(named: imageName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myLabel.text = nil
        myImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = contentView.frame.size.height-6
        
//        let switchSize = _switch.sizeThatFits(contentView.frame.size)
//
//
//        _switch.frame = CGRect(x: (contentView.frame.size.width-switchSize.width)-15,
//                               y: (contentView.frame.size.height-switchSize.height)/2,
//                               width: switchSize.width,
//                               height: switchSize.height)
        
        let buttonSize = startButton.sizeThatFits(contentView.frame.size)
        
        
        startButton.frame = CGRect(x: (contentView.frame.size.width-buttonSize.width)-15,
                               y: (contentView.frame.size.height-buttonSize.height)/2,
                               width: buttonSize.width,
                               height: buttonSize.height)
        
        startButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        myLabel.frame = CGRect(x: 15+myImageView.frame.size.width,
                               y: 0,
                               width: contentView.frame.size.width - 35 - startButton.frame.size.width - imageSize,
                               height: contentView.frame.size.height)
        
 
//        myLabel.frame = CGRect(x: 15+myImageView.frame.size.width,
//                               y: 0,
//                               width: contentView.frame.size.width - 10 - _switch.frame.size.width - imageSize,
//                               height: contentView.frame.size.height)
//
        
        myImageView.frame = CGRect(x: 6, y: 3, width: imageSize, height: imageSize)
    
    
        
  
 //this is the past layout from vid
        
//        _switch.frame = CGRect(x: 5,
//                               y: (contentView.frame.size.height-switchSize.height)/2,
//                               width: switchSize.width,
//                               height: switchSize.height)
        
//        myLabel.frame = CGRect(x: 20+_switch.frame.size.width,
//                               y: 0,
//                               width: contentView.frame.size.width - 10 - _switch.frame.size.width - imageSize,
//                               height: contentView.frame.size.height)
        
//        myImageView.frame = CGRect(x: contentView.frame.size.width-imageSize, y: 3, width: imageSize, height: imageSize)
    
    }
    
    @objc func buttonAction(){
        print("Testing: Button tapped")
    }
    
    
}
