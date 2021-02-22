//
//  User.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/22/21.
//

import UIKit

struct User {
    
    let uid: String
    let username: String
    let firstName: String
    let lastName: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
    }

}


