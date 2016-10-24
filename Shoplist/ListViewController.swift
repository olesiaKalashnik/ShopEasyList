//
//  ListViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 6/26/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hideCompletedOutlet: UIBarButtonItem!
    
    var currentList : List!
    var selectedItemWithoutDetails : Item?
    var selectedItemWithDetails : Item?
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupAppearance()
        self.updateUI()
    }
    
    func updateUI() {
        currentList.items = Library.shared.itemsInList(list: self.currentList)
        self.hideCompletedOutlet.isEnabled = currentList.items.count > 0
        self.tableView.reloadData()
    }
    
    //Helper Function
    func itemsGrouped() -> [[Item]] {
        func unique<C : Sequence, T : Hashable>(_ inputArray: C) -> [T] where C.Iterator.Element == T {
            var addedDict = [T:Bool]()
            return inputArray.filter { addedDict.updateValue(true, forKey: $0) == nil }
        }
        let categories = unique(currentList.items.map { $0.category })
        var itemsGrouped = [[Item]]()
        for category in categories {
            itemsGrouped.append(currentList.items.filter {$0.category == category} )
        }
        return itemsGrouped
    }
    
    @IBAction func hideCompleted(_ sender: UIBarButtonItem) {
        for item in Library.shared.items {
            if item.isCompleted {
                item.list = nil
                item.isCompleted = false
                item.numOfPurchaces += 1
                item.lastTimeAddedToList = Date()
            }
        }
        
        currentList.items = Library.shared.itemsInList(list: currentList)
        self.hideCompletedOutlet.isEnabled = currentList.items.count > 0
        self.tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination as UIViewController
        
        if segue.identifier == LibraryViewController.id {
            guard let tabBarController = destination as? UITabBarController else { return }
            guard let tabBarVCs = tabBarController.viewControllers else { return }
            guard let navController = tabBarVCs.first as? UINavigationController else {return}
            destination = navController.visibleViewController!
            if let libraryVC = destination as? LibraryViewController {
                libraryVC.currList = self.currentList
                libraryVC.listVC = self
            }
        }
        if segue.identifier == AddItemTableViewController.id {
            if let navController = destination as? UINavigationController {
                guard let addVC = navController.visibleViewController as? AddItemTableViewController else { return }
                
                if let indexPath = self.tableView.indexPath(for: sender as!ListItemWithDetailsTableViewCell) {
                    var allItemsBySection = self.itemsGrouped()
                    addVC.item = allItemsBySection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
                }
                
            }
        }
    }
}

extension ListViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Set(currentList.items.map({$0.category})).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = itemsGrouped()[section].first else {return nil}
        return item.category
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Defaults.UI.blueTransperent
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsGrouped()[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var allItemsBySection = itemsGrouped()
        let item = allItemsBySection[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        if item.detailsText != "" {
            self.tableView.rowHeight = Defaults.UI.detailsRowHeight
        } else {
            self.tableView.rowHeight = Defaults.UI.noDetailsRowHeight
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ListItemWithDetailsTableViewCell.id, for: indexPath) as! ListItemWithDetailsTableViewCell
        cell.listItem = item
        
        return cell
    }
}

//MARK: - TableView Delegate Methods
extension ListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
}

extension ListViewController : Setup {
    func setup() {
        if currentList == nil {
            self.currentList = List(items: [Item]())
        }
        
        self.hideCompletedOutlet.isEnabled = currentList.items.count > 0
        
        self.tableView?.backgroundView = UIImageView(image: UIImage(imageLiteralResourceName: Defaults.UI.textureImage))
        for item in self.navigationItem.leftBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
        for item in self.navigationItem.rightBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
    }
    
    func setupAppearance() {
        self.navigationItem.title = self.currentList.name
        
        for cell in self.tableView.visibleCells {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
    }
}

