//
//  MenuVC.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/18/21.
//

import UIKit

class MenuVC: UIViewController {
    
    //
    // MARK: View Lifecycle
    //
    
    override func viewDidLoad() {
        setUpViews()
    }
    
    //
    // MARK: Functions
    //
    


    //
    // MARK: UI Setup
    //
    
    let tempLabel: UILabel = {
        let lbl = UILabel()
        lbl.add(text: "This is the menu screen.", font: UIFont(regularWithSize: 23), textColor: .main_label)
        lbl.textAlignment = .center
        return lbl
    }()
    
    func setUpViews() {
                
        self.view.backgroundColor = .green

    }

}
