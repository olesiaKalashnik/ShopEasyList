//
//  Identity.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

protocol Identity {
    static var id : String {get}
}

extension Identity {
    static var id : String {
        return String(self)
    }
}