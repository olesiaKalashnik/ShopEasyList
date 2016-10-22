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
    var name = "New List"
    var id : String
    var color : UIColor
    
    private let colors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.purple, UIColor.yellow, UIColor.brown, UIColor.gray, UIColor.cyan]
    
    init(items: [Item], name: String = "New List", id : String = UUID().uuidString) {
        self.items = items
        self.name = name
        self.color = colors[Int.random(maxValue: colors.count)]
        self.id = id
        print(id)
    }
    
    struct PropertyKeys {
        static let id = "id"
        static let name = "name"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lists")
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKeys.id)
        aCoder.encode(name, forKey: PropertyKeys.name)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: PropertyKeys.id) as! String
        let name = aDecoder.decodeObject(forKey: PropertyKeys.name) as! String
        self.init(items: [Item](), name: name, id: id)
    }
    
}

extension Int {
    static func random(maxValue: Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxValue)))
    }
}
