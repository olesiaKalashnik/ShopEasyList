//
//  ItemStoreProtocol.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

protocol ItemStoreProtocol : class {
    var items : [Item] {get set }
    var categories : [String]  { get }
    func add(_ item: Item)
    func remove(_ item: Item)
    func unique<C : Sequence, T : Hashable>(_ inputArray: C) -> [T] where C.Iterator.Element == T
    var categoryToItemDictionary : [String: [Item]] { get }
    var groupedItemsAsList : [[Item]] { get }
    func itemsInList(list: List) -> [Item]
    func editDetails(_ item: Item)
}

extension ItemStoreProtocol {
    
    func add(_ item: Item) {
        if !self.items.contains(where: {($0.name == item.name) && ($0.category == item.category)}) {
            self.items.append(item)
        }
    }
    
    func remove(_ item: Item) {
        self.items = self.items.filter {!(($0.name == item.name) && ($0.category == item.category))}
    }
    
    var categories : [String] {
        return self.items.map {$0.category}
    }
    
    func unique<C : Sequence, T : Hashable>(_ inputArray: C) -> [T] where C.Iterator.Element == T {
        var addedDict = [T:Bool]()
        return inputArray.filter { addedDict.updateValue(true, forKey: $0) == nil }
    }
    
    var categoryToItemDictionary : [String: [Item]] {
        let uniqueCategoriesArr = self.unique(self.categories)
        var dict = [String: [Item]]()
        for category in uniqueCategoriesArr {
            dict[category] = self.items.filter { $0.category == category }
        }
        return dict
    }
    
    var groupedItemsAsList : [[Item]] {
        let categorizedItems = self.categoryToItemDictionary
        return categorizedItems.values.map { $0 }
    }
    
    func itemsInList(list: List) -> [Item] {
        
        return self.items.filter{$0.list?.id == list.id}
    }
    
    func editDetails(_ itemToEdit: Item) {
        for item in self.items {
            if (item.name == itemToEdit.name) && (item.category == itemToEdit.category) {
                item.detailsText = itemToEdit.detailsText
                item.image = itemToEdit.image
            }
        }
    }
}
