//
//  LibraryTableViewCell.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/30/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completionCheckbox: CheckboxButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var currList : List? {
        didSet {
            self.setup()
        }
    }
    
    var libraryItem : Item? {
        didSet {
            self.setup()
        }
    }
    
    @IBAction func completionChecked(_ sender: CheckboxButton) {
        sender.isSelected = !sender.isSelected
        if let currList = self.currList, let libraryItem = self.libraryItem {
            if sender.isSelected && !libraryItem.lists.contains(where: { (list) -> Bool in
                list.id == currList.id
            }) {
                    libraryItem.lists.append(currList)
            }
            else {
                libraryItem.lists = libraryItem.lists.filter {$0.id != currList.id}
            }
        }
        libraryItem?.isCompleted = false
    }
}

extension LibraryTableViewCell : Setup {
    
    func setup() {
        guard let item = self.libraryItem else { return }
        self.nameLabel?.text = item.name.lowercased()
        if let currList = self.currList {
            self.completionCheckbox.isSelected = Library.shared.itemsInList(list: currList).contains(item)
        }
        itemImageView.image = item.image
        self.itemImageView?.layer.cornerRadius = 5.0
        
    }
    
    func setupAppearance() {
    }
}
