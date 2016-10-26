//
//  CollectionOfLists.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 10/23/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation
class CollectionOfLists : Savable {
    
    // Savable protocol
    typealias Object = List
    var path = Object.ArchiveURL.path
    
    static let shared = CollectionOfLists()
    fileprivate init() {
        self.items = NSKeyedUnarchiver.unarchiveObject(withFile: self.path) as? [Object] ?? [Object]()
    }
    
    var items : [Object]
    
    init(items: [Object]) {
        self.items = items
    }
    
    //Managing the store
    func add(list: List) {
        self.items.append(list)
    }
    
    func lastOpenList() -> List? {
        return self.items.filter {$0.lastOpen}.first
    }
    
    func setListLastOpenToFalse() {
        for list in self.items {
            list.lastOpen = false
        }
    }
    
    func getAllLists() -> [List] {
        return self.items
    }
    
    
    
}
