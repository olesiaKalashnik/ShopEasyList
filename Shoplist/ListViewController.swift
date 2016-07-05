//
//  ListViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

protocol ListViewControllerDelegate {
    func updateItem() -> Item?
}

class ListViewController: UIViewController, ItemStoreProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var hideCompletedOutlet: UIBarButtonItem!
    
    var delegate : ListViewControllerDelegate?
    
    var items = Library.shared.itemsInList { // Library.shared.items.filter({$0.isInList}) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var itemBeingEdited : Item?
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.updateUI()
    }
    
    var passedItem: Item?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print(passedItem?.detailsText)
        
//        if let delegate = self.delegate {
//            delegate.updateItem()
//        }
        updateUI()
    }
    
    func updateUI() {
        self.items = Library.shared.itemsInList   //Library.shared.items.filter({$0.isInList})
        hideCompletedOutlet.enabled = self.items.count > 0
        self.tableView.reloadData()
    }
    
    @IBAction func hideCompleted(sender: UIBarButtonItem) {
        for item in items {
            if item.isCompleted {
                item.isInList = false
                item.numOfPurchaces += 1
                item.lastTimeAddedToList = NSDate()
            }
        }
        self.hideCompletedOutlet.enabled = items.filter({$0.isInList}).count > 0
        self.items = Library.shared.itemsInList  //Library.shared.items.filter({$0.isInList})
    }
    
//    var groupedItemsAsList : [[Item]] {
//        let categorizedItems = self.categoryToItemDictionary
//        return categorizedItems.values.map { $0 }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        if segue.identifier == "LibraryViewController" {
            guard let tabBarController = destination as? UITabBarController else { return }
            guard let tabBarVCs = tabBarController.viewControllers else { return }
            guard let navController = tabBarVCs.first as? UINavigationController else {return}
            destination = navController.visibleViewController!
            if let libraryVC = destination as? LibraryViewController {
                libraryVC.currentList = self.items
                libraryVC.listVC = self
            }
        }
        else if segue.identifier == AddItemTableViewController.id {
            if let navController = destination as? UINavigationController {
                guard let addVC = navController.visibleViewController as? AddItemTableViewController else { return }
                guard let indexPath = self.tableView.indexPathForCell(sender as! ListItemWithDetailsTableViewCell) else { return }
                var allItemsBySection = Library.shared.groupedListItems //self.groupedItemsAsList
                addVC.item = allItemsBySection[indexPath.section][indexPath.row]
                passedItem = allItemsBySection[indexPath.section][indexPath.row]
                print(addVC.item?.name)
            }
        }
    }
    
}


extension ListViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Set(self.categories).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = Library.shared.groupedListItems[section].first else {return nil}  //self.groupedItemsAsList[section].first else {return nil}
        return item.category
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let items = self.categoryToItemDictionary[self.categoryToItemDictionary.keys.map({$0})[section]] else { return 0 }
        guard let items = Library.shared.categoryToListItemDictionary[self.categoryToListItemDictionary.keys.map({$0})[section]] else { return 0 }

        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ListItemWithDetailsTableViewCell.id, forIndexPath: indexPath) as! ListItemWithDetailsTableViewCell
        var allItemsBySection = Library.shared.groupedListItems //self.groupedItemsAsList
        cell.listItem = allItemsBySection[indexPath.section][indexPath.row]
        return cell
    }
}
//MARK: - TableView Delegate Methods

extension ListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
}

extension ListViewController : Setup {
    func setup() {
        self.hideCompletedOutlet.enabled = self.items.count > 0
        self.navigationItem.title = "List"
    }
    
    func setupAppearance() {
        
    }
}

