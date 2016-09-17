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
    
    @IBAction func completionChecked(_ sender: CheckboxButton) {
        completionButton.isSelected = !completionButton.isSelected
        guard let item = self.listItem else { return }
        item.isCompleted = sender.isSelected
    }
}

extension ListItemWithDetailsTableViewCell : Setup {
    func setup() {
        guard let item = self.listItem else { return }
        self.nameLabel?.text = item.name.lowercased()
        self.completionButton.isSelected = item.isCompleted
        guard let detail = item.detailsText else { return }
        self.detailsLabel?.text = detail
    }
    
    func setupAppearance() {
        //
    }
}
