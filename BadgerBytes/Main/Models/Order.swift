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
    let pickupDate: Date
    let carDesc: String
    let priority: String

    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.ownerID = dictionary["ownerID"] as? String ?? ""
        self.menuItems = dictionary["menuItems"] as? [String: Any] ?? ["":""]
        let intPrice = dictionary["totalPrice"] as? Int ?? 0
        self.totalPrice = "\(intPrice)"
        self.status = dictionary["status"] as? String ?? ""
        let creationSeconds = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationSeconds)
        let pickupSeconds = dictionary["pickupDate"] as? Double ?? 0
        self.pickupDate = Date(timeIntervalSince1970: pickupSeconds)
        self.carDesc = dictionary["carDesc"] as? String ?? ""
        self.priority = dictionary["priority"] as? String ?? ""

    }

}
