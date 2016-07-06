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
    
    var items = Library.shared.itemsInList
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    func updateUI() {
        self.items = Library.shared.itemsInList
        self.hideCompletedOutlet.enabled = self.items.count > 0
        self.tableView.reloadData()
    }
    
    @IBAction func hideCompleted(sender: UIBarButtonItem) {
        //for item in items {
        for item in Library.shared.items {
            if item.isCompleted {
                item.isInList = false
                item.isCompleted = false
                item.numOfPurchaces += 1
                item.lastTimeAddedToList = NSDate()
            }
        }
        
        self.items = Library.shared.itemsInList
        self.hideCompletedOutlet.enabled = items.filter({$0.isInList}).count > 0
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if segue.identifier == LibraryViewController.id {
            guard let tabBarController = destination as? UITabBarController else { return }
            guard let tabBarVCs = tabBarController.viewControllers else { return }
            guard let navController = tabBarVCs.first as? UINavigationController else {return}
            destination = navController.visibleViewController!
            if let libraryVC = destination as? LibraryViewController {
                libraryVC.currentList = self.items
                libraryVC.listVC = self
            }
        }
        if segue.identifier == AddItemTableViewController.id {
            if let navController = destination as? UINavigationController {
                guard let addVC = navController.visibleViewController as? AddItemTableViewController else { return }
                guard let indexPath = self.tableView.indexPathForCell(sender as! ListItemWithDetailsTableViewCell) else { return }
                var allItemsBySection = Library.shared.groupedListItems
                addVC.item = allItemsBySection[indexPath.section][indexPath.row]
                print(addVC.item?.name)
            }
        }
    }
}


extension ListViewController : UITableViewDataSource {
    
    
    func itemsGrouped() -> [[Item]] {
        func unique<C : SequenceType, T : Hashable where C.Generator.Element == T>(inputArray: C) -> [T] {
            var addedDict = [T:Bool]()
            return inputArray.filter { addedDict.updateValue(true, forKey: $0) == nil }
        }
        
        let categories = unique(self.items.map({ $0.category }))
        var itemsGrouped = [[Item]]()
        for category in categories {
            itemsGrouped.append(self.items.filter( {$0.category == category} ))
        }
        return itemsGrouped
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Set(self.categories).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = itemsGrouped()[section].first else {return nil}
        return item.category
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsGrouped()[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ListItemWithDetailsTableViewCell.id, forIndexPath: indexPath) as! ListItemWithDetailsTableViewCell
        var allItemsBySection = itemsGrouped()
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

