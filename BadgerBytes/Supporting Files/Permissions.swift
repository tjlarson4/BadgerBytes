//
//  Permissions.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/25/21.
//

import Foundation
import Firebase

enum AccountType {
    case customer
    case staff
    case admin
}

class Permissions {
    
    static let service = Permissions()
    
    func checkAccountType(user: User) -> AccountType {
        
        Database.fetchUserWithUID(uid: user.uid, completion: { (user) in
            
            let accountType = user.accountType
            
            if accountType == "customer" {
                return .customer
            } else if accountType == "staff" {
                return .staff
            }
            
            
        })

        
        
    }
    
    
}



