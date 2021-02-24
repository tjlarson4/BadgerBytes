//
//  MenuItem.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/24/21.
//

import UIKit

struct MenuItem {
    
    let imageURL: String
    let name: String
    let price: String
    let category: String
    
    init(name: String, price: String, category: String, imageURL: String) {
        self.name = name
        self.price = price
        self.category = category
        self.imageURL = imageURL
    }
    
    init(dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.price = dictionary["price"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
    }

}
