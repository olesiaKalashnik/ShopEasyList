//
//  ListItemWithDetailsTableViewCell.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class ListItemWithDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completionButton: CheckboxButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var listItem : Item? {
        didSet {
            self.setup()
        }
    }
    
    @IBAction func completionChecked(sender: CheckboxButton) {
        completionButton.selected = !completionButton.selected
        guard let item = self.listItem else { return }
        item.isCompleted = sender.selected
    }
}

extension ListItemWithDetailsTableViewCell : Setup {
    func setup() {
        guard let item = self.listItem else { return }
        self.nameLabel?.text = item.name
        self.completionButton.selected = item.isCompleted
        guard let detail = item.detailsText else { return }
        self.detailsLabel?.text = detail
    }
    
    func setupAppearance() {
        
    }
}
