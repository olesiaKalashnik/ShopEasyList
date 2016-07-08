//
//  Savable.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/1/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

protocol Savable : class {
    associatedtype Object : NSObject
    var path : String {get set}
    var items : [Object] {get set}
    func saveObjects()
}

extension Savable {
    func saveObjects() {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.items, toFile: self.path)
            if !isSuccessfulSave {
                print("Failed to save items...")
        }
    }
}
