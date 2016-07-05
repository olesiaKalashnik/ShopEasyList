//
//  FavoritesViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/5/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var library = Library.shared
    
    
    var favoriteItems = Library.shared.items.sort { (item1, item2) -> Bool in
        item1.numOfPurchaces > item2.numOfPurchaces} {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func doneButtonSelected(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FavoritesViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.library.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LibraryTableViewCell.id, forIndexPath: indexPath) as! LibraryTableViewCell
        cell.libraryItem = self.favoriteItems[indexPath.row]
        return cell
    }
}
