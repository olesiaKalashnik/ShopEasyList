//
//  ListViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, ItemStoreProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var hideCompletedOutlet: UIBarButtonItem!
    
    var items = Library.shared.items.filter({$0.isInList}) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        self.items = Library.shared.items.filter({$0.isInList})
        hideCompletedOutlet.enabled = self.items.count > 0
        self.tableView.reloadData()
    }
    
    @IBAction func hideCompleted(sender: UIBarButtonItem) {
        for item in items {
            if item.isCompleted {
                item.isInList = false
                item.numOfPurchaces += 1
            }
        }
        self.hideCompletedOutlet.enabled = items.filter({$0.isInList}).count > 0
        self.items = Library.shared.items.filter({$0.isInList})
    }
    
    var groupedItemsAsList : [[Item]] {
        let categorizedItems = self.categoryToItemDictionary
        return categorizedItems.values.map { $0 }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LibraryViewController" {
            var destination = segue.destinationViewController as UIViewController
            guard let tabBarController = destination as? UITabBarController else { return }
            guard let tabBarVCs = tabBarController.viewControllers else { return }
            guard let navController = tabBarVCs.first as? UINavigationController else {return}
            destination = navController.visibleViewController!
            if let libraryVC = destination as? LibraryViewController {
                libraryVC.currentList = self.items
                libraryVC.listVC = self
            }
        }
    }
    
}


extension ListViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Set(self.categories).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = self.groupedItemsAsList[section].first else {return nil}
        return item.category
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.categoryToItemDictionary[self.categoryToItemDictionary.keys.map({$0})[section]] else { return 0 }
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ListItemWithDetailsTableViewCell.id, forIndexPath: indexPath) as! ListItemWithDetailsTableViewCell
        var allItemsBySection = self.groupedItemsAsList
        cell.listItem = allItemsBySection[indexPath.section][indexPath.row]
        return cell
    }
}

extension ListViewController : UITableViewDelegate {
    
}

extension ListViewController : Setup {
    func setup() {
        self.hideCompletedOutlet.enabled = self.items.count > 0
        self.navigationItem.title = "List"
    }
    
    func setupAppearance() {
        
    }
}

