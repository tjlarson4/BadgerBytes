//
//  UsageItem.swift
//  BadgerBytes
//
//  Created by Thor Larson on 2/26/21.
//

import UIKit

enum UsageType: String {
    case empty
    case userSignUP
    case menuItemCreated
    case orderCreated
    case orderCompleted
    case orderReactivated
}

struct UsageItem {
    
    let type: UsageType
    let desc: String
    let actionDate: Date
    let actingUserID: String
    
    init(type: UsageType, desc: String, actingUserID: String) {
        self.type = type
        self.desc = desc
        self.actingUserID = actingUserID
        self.actionDate = Date()
    }
    
    init(id: String, dictionary: [String: Any]) {
        self.type = UsageType(rawValue: dictionary["type"] as? String ?? "") ?? .empty
        self.desc = dictionary["desc"] as? String ?? ""
        self.actingUserID = dictionary["actingUserID"] as? String ?? ""
        let actionSeconds = dictionary["actionDate"] as? Double ?? 0
        self.actionDate = Date(timeIntervalSince1970: actionSeconds)
    }
    
    func toDict() -> [String: Any] {
        return ["type": type.rawValue, "desc": desc, "actingUserID": actingUserID, "actionDate": actionDate.timeIntervalSince1970]
    }
}
