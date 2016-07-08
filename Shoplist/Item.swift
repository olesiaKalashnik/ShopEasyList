//
//  Item.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class Item : NSObject, NSCoding {
    let name: String
    let category : String
    var isInList : Bool
    var isCompleted : Bool
    var detailsText : String?
    var image: UIImage?
    var lastTimeAddedToList: NSDate?
    var numOfPurchaces : Int
    
    init(name: String, category: String, isInList : Bool = false, completed: Bool = false, details: String? = nil, image : UIImage? = nil, isCompleted: Bool = false, addTime: NSDate? = nil, numOfPurchaces : Int = 0) {
        self.name = name
        self.category = category
        self.isInList = isInList
        self.isCompleted = completed
        self.detailsText = details
        self.image = image
        self.lastTimeAddedToList = addTime
        self.numOfPurchaces = numOfPurchaces
    }
    
    struct PropertyKey {
        static let name = "name"
        static let category = "category"
        static let isInList = "isInList"
        static let isCompleted = "isCompleted"
        static let detailsText = "detailsText"
        static let image = "image"
        static let lastTimeAddedToList = "lastTimeAddedToList"
        static let numOfPurchaces = "numOfPurchaces"
    }
    
    func equals(item: Item) -> Bool {
        return (self.name == self.name) && (self.category == item.category)
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("items")
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.name)
        aCoder.encodeObject(category, forKey: PropertyKey.category)
        aCoder.encodeObject(isInList, forKey: PropertyKey.isInList)
        aCoder.encodeObject(isCompleted, forKey: PropertyKey.isCompleted)
        aCoder.encodeObject(detailsText, forKey: PropertyKey.detailsText)
        aCoder.encodeObject(image, forKey: PropertyKey.image)
        aCoder.encodeObject(lastTimeAddedToList, forKey: PropertyKey.lastTimeAddedToList)
        aCoder.encodeObject(numOfPurchaces, forKey: PropertyKey.numOfPurchaces)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.name) as! String
        let category = aDecoder.decodeObjectForKey(PropertyKey.category) as! String
        let isInList = aDecoder.decodeObjectForKey(PropertyKey.isInList) as! Bool
        let isCompleted = aDecoder.decodeObjectForKey(PropertyKey.isCompleted) as! Bool
        let detailsText = aDecoder.decodeObjectForKey(PropertyKey.detailsText) as? String
        let image = aDecoder.decodeObjectForKey(PropertyKey.image) as? UIImage
        let lastTimeAddedToList = aDecoder.decodeObjectForKey(PropertyKey.lastTimeAddedToList) as? NSDate
        let numOfPurchaces = aDecoder.decodeObjectForKey(PropertyKey.numOfPurchaces) as! Int
        
        self.init(name: name, category: category, isInList: isInList, completed: isCompleted, details: detailsText, image: image, addTime: lastTimeAddedToList, numOfPurchaces: numOfPurchaces)
    }
    
}