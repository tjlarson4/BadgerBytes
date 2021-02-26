//
//  FirebaseUtils.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/25/21.
//

import UIKit
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    
    static func fetchMenuItemWithID(id: String, completion: @escaping (MenuItem) -> ()) {
        Database.database().reference().child("menuItems").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let menuItemDictionary = snapshot.value as? [String: Any] else { return }
            let menuItem = MenuItem(id: id, dictionary: menuItemDictionary)
            completion(menuItem)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
    
    
    
}
