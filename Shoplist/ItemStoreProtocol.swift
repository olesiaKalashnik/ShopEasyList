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
    func add(item: Item)
    func remove(item: Item)
    func unique<C : SequenceType, T : Hashable where C.Generator.Element == T>(inputArray: C) -> [T]
    var categoryToItemDictionary : [String: [Item]] { get }
    var groupedItemsAsList : [[Item]] { get }
    var groupedListItems : [[Item]] { get }
    var itemsInList : [Item] { get }
    func editDetails(item: Item)
}

extension ItemStoreProtocol {
    
    func add(item: Item) {
        if !self.items.contains({($0.name == item.name) && ($0.category == item.category)}) {
            self.items.append(item)
        }
    }
    
    func remove(item: Item) {
        self.items = self.items.filter {!(($0.name == item.name) && ($0.category == item.category))}
    }
    
    var categories : [String] {
        return self.items.map {$0.category}
    }
    
    func unique<C : SequenceType, T : Hashable where C.Generator.Element == T>(inputArray: C) -> [T] {
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
    
    var itemsInList : [Item] {
        return self.items.filter{$0.isInList}
    }
    
    var categoryToListItemDictionary : [String: [Item]] {
        var dict = [String: [Item]]()
        for category in self.itemsInList.map({$0.category}) {
            if dict[category] == nil {
                dict[category] = self.items.filter { $0.category == category }
            }
        }
        return dict
    }
    
    var groupedListItems : [[Item]] {
        let categorizedListItems = self.categoryToListItemDictionary
        return categorizedListItems.values.map { $0 }
    }
    
    func editDetails(itemToEdit: Item) {
        for item in self.items {
            if (item.name == itemToEdit.name) && (item.category == itemToEdit.category) {
                item.detailsText = itemToEdit.detailsText
            }
        }
//        if self.items.contains({($0.name == item.name) && ($0.category == item.category)}) {
//            self.items.append(item)
//        }
    }
}
