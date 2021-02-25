//
//  Order.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/22/21.
//

import UIKit

struct Order {
    
    let ownerID: String
    let menuItems: [String: Any]
    let totalPrice: String
    let creationDate: Date
    let status: String
    let id: String
//    let timeToPickup: String
//    let carDesc: String

    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.ownerID = dictionary["ownerID"] as? String ?? ""
        self.menuItems = dictionary["menuItems"] as? [String: Any] ?? ["":""]
        self.totalPrice = dictionary["totalPrice"] as? String ?? ""
        self.status = dictionary["status"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
//        self.timeToPickup = dictionary["timeToPickup"] as? String ?? ""
//        self.carDesc = dictionary["carDesc"] as? String ?? ""

    }

}

