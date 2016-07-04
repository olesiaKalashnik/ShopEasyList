//
//  TableViewHelpers.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/30/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

protocol TableViewHelpers {
    func unique<C : SequenceType, T : Hashable where C.Generator.Element == T>(inputArray: C) -> [T]
    var categoryToItemDictionary : [String: [Item]] {get}
    var groupedItemsAsList : [[Item]] {get}
}

extension TableViewHelpers {
    func unique<C : SequenceType, T : Hashable where C.Generator.Element == T>(inputArray: C) -> [T] {
        var addedDict = [T:Bool]()
        return inputArray.filter { addedDict.updateValue(true, forKey: $0) == nil }
    }
}