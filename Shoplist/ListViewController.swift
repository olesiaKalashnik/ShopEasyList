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
    
    private struct TableViewConstants {
        static let detailsRowHeight = CGFloat(55.0)
        static let noDetailsRowHeight = CGFloat(44.0)
    }
    
    @IBOutlet weak var hideCompletedOutlet: UIBarButtonItem!
    
    var items = Library.shared.itemsInList
    var selectedItemWithoutDetails : Item?
    var selectedItemWithDetails : Item?
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        //        self.tableView.registerNib(UINib(nibName: "NoDetailsCell", bundle: nil), forCellReuseIdentifier: NoDetailsListItemTableViewCell.id)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
        self.updateUI()
    }
    
    func updateUI() {
        self.items = Library.shared.itemsInList
        self.hideCompletedOutlet.enabled = self.items.count > 0
        self.tableView.reloadData()
    }
    
    //Helper Function
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
    
    @IBAction func hideCompleted(sender: UIBarButtonItem) {
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
                
                if let indexPath = self.tableView.indexPathForCell(sender as!ListItemWithDetailsTableViewCell) {
                    var allItemsBySection = self.itemsGrouped()
                    addVC.item = allItemsBySection[indexPath.section][indexPath.row]
                }
                
                
                //                if sender is NoDetailsListItemTableViewCell {
                //                    print("Sender is NoDetailsListItemTableViewCell")
                
                //if let indexPath = self.tableView.indexPathForCell(sender as! NoDetailsListItemTableViewCell) {
                
                //var allItemsBySection = Library.shared.groupedListItems
                //addVC.item = selectedItemWithoutDetails //allItemsBySection[indexPath.section][indexPath.row]
                //}
                
                //} else {
            }
        }
    }
}

extension ListViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Set(self.categories).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = itemsGrouped()[section].first else {return nil}
        return item.category
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 50/255, green: 170/255, blue: 240/255, alpha: 0.4)
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsGrouped()[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var allItemsBySection = itemsGrouped()
        let item = allItemsBySection[indexPath.section][indexPath.row]
        //        if item.detailsText != "" {
        //
        let cell = tableView.dequeueReusableCellWithIdentifier(ListItemWithDetailsTableViewCell.id, forIndexPath: indexPath) as! ListItemWithDetailsTableViewCell
        cell.listItem = item
        
        self.tableView.rowHeight = TableViewConstants.detailsRowHeight
        
        return cell
        //
        //        } else {
        //        let cell = tableView.dequeueReusableCellWithIdentifier(NoDetailsListItemTableViewCell.id, forIndexPath: indexPath) as! NoDetailsListItemTableViewCell
        //        cell.listItem = item
        //        self.tableView.rowHeight = TableViewConstants.noDetailsRowHeight
        //
        //        return cell
        //}
    }
}

//MARK: - TableView Delegate Methods
extension ListViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
    }
    
    //    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    //        var allItemsBySection = itemsGrouped()
    //        let item = allItemsBySection[indexPath.section][indexPath.row]
    //        print("accessoryButtonTappedForRowWithIndexPath: \(item.name), \(item.detailsText)")
    //
    //        if item.detailsText != "" {
    //            selectedItemWithDetails = item
    //            selectedItemWithoutDetails = nil
    //            performSegueWithIdentifier(AddItemTableViewController.id, sender: ListItemWithDetailsTableViewCell(style: .Default, reuseIdentifier: AddItemTableViewController.id))
    //            self.tableView.reloadData()
    //        } else {
    //            if item.detailsText == "" {
    //                selectedItemWithoutDetails = item
    //                selectedItemWithDetails = nil
    //
    //                performSegueWithIdentifier(AddItemTableViewController.id, sender: NoDetailsListItemTableViewCell(style: .Default, reuseIdentifier: AddItemTableViewController.id))
    //                self.tableView.reloadData()
    //
    //            }
    //        }
    //    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
}

extension ListViewController : Setup {
    func setup() {
        self.hideCompletedOutlet.enabled = self.items.count > 0
        self.navigationItem.title = "List"
        self.tableView?.backgroundView = UIImageView(image: UIImage(imageLiteral: "texture1"))
        for item in self.navigationItem.leftBarButtonItems! {
            item.tintColor = UIColor(red: 50/255, green: 170/255, blue: 240/255, alpha: 1)
        }
        for item in self.navigationItem.rightBarButtonItems! {
            item.tintColor = UIColor(red: 50/255, green: 170/255, blue: 240/255, alpha: 1)
        }
    }
    
    func setupAppearance() {
        for cell in self.tableView.visibleCells {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
}

