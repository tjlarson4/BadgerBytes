//
//  Order.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/22/21.
//

import UIKit

struct Order {
    
    let ownerID: String
    let title: String
    let subtitle: String
    let imageName: String
    
    init(dictionary: [String: Any]) {
        self.ownerID = dictionary["ownerID"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.subtitle = dictionary["subtitle"] as? String ?? ""
        self.imageName = "food1"
    }

}

