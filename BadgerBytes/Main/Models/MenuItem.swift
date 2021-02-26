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
    let id: String
    let inStock: Bool
    
    init(name: String, price: String, category: String, imageURL: String, id: String, inStock: Bool) {
        self.name = name
        self.price = price
        self.category = category
        self.imageURL = imageURL
        self.id = id
        self.inStock = inStock
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.price = dictionary["price"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.inStock = dictionary["inStock"] as? Bool ?? true
        self.id = id
    }

}
