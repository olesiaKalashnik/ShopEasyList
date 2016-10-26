//
//  List.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 10/18/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class List : NSObject, ItemStoreProtocol, NSCoding {
    
    var items: [Item]
    var name : String
    var id : String
    var lastOpen : Bool
    
    init(items: [Item], name: String = "New List", id : String = UUID().uuidString, lastOpen: Bool = false) {
        self.items = items
        self.name = name
        self.id = id
        self.lastOpen = lastOpen
    }
    
    // MARK: - Encoding & Decoding
    struct PropertyKeys {
        static let id = "id"
        static let name = "name"
        static let lastOpen = "lastOpen"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lists")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKeys.id)
        aCoder.encode(name, forKey: PropertyKeys.name)
        aCoder.encode(lastOpen, forKey: PropertyKeys.lastOpen)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: PropertyKeys.id) as! String
        let name = aDecoder.decodeObject(forKey: PropertyKeys.name) as! String
        let lastOpen = aDecoder.decodeBool(forKey: PropertyKeys.lastOpen)
        self.init(items: [Item](), name: name, id: id, lastOpen: lastOpen)
    }
    
    static func ==(_ lhs: List, _ rhs: List) -> Bool {
        return lhs.id == rhs.id
    }
    
}
