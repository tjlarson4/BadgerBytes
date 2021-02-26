//
//  User.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/22/21.
//

import UIKit

struct User {
    
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let accountType: String
    let phoneNum: String
    let address: String
    let payment: [String: String]
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? String ?? ""
        self.phoneNum = dictionary["phoneNum"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
        self.payment = dictionary["payment"] as? [String: String] ?? ["":""]
    }

}


