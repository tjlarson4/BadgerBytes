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
    
    static func uploadUsageAction(usageItem: UsageItem) {
        let values = usageItem.toDict()
        Database.database().reference().child("usage").childByAutoId().updateChildValues(values)
    
    }
    
    static func fetchCurrentUser() {
        
        // Checks that there is a current user with an ID
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        
        // Retrieves user info from Firebase
        Database.database().reference().child("Users").child(currentUserID).observeSingleEvent(of: .value) { (snapshot) in
            
            // Creates dictionary of user information, instatiates new User object
            guard let userDict = snapshot.value as? [String: Any] else {return}
            globalCurrentUser = User(uid: currentUserID, dictionary: userDict)
        }
    }
    
    
    
}
