//
//  Library.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class Library: Savable, ItemStoreProtocol {
    typealias Object = Item
    
    var path = Item.ArchiveURLForItems.path
    
    static let shared = Library()
    fileprivate init() {
        self.items = NSKeyedUnarchiver.unarchiveObject(withFile: self.path) as? [Object] ?? [Object]()
    }
    
    var items : [Object]
    
    init(items: [Object]) {
        self.items = items
    }

    //Computed Variables and Methods
    func getSelectedItems(inList: List) -> [Object] {
        return self.items.filter {$0.lists.contains(where: { (list) -> Bool in
            list.id == inList.id
        })}
    }
    
    
}
