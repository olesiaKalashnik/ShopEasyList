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
    
    var path = Item.ArchiveURL.path
    
    static let shared = Library()
    fileprivate init() {
        self.items = NSKeyedUnarchiver.unarchiveObject(withFile: self.path) as? [Object] ?? [Object]()
    }
    
    var items : [Object]
    
    init(items: [Item]) {
        self.items = items
    }
    
    func addLibraryItem(_ item: Item) {
        Library.shared.items.append(item)
    }
    
    //Computed Variables and Methods
    func getSelectedItems() -> [Item] {
        return self.items.filter {$0.isInList}
    }
    
    
}
