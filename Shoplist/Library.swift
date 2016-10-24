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
    
    init(items: [Item]) {
        self.items = items
    }
    
    func addLibraryItem(_ item: Item) {
        Library.shared.items.append(item)
    }
    
    //Computed Variables and Methods
    func getSelectedItems(inList: List) -> [Item] {
        return self.items.filter {$0.list?.id == inList.id}
    }
    
    
}
