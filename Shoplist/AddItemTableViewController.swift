//
//  AddItemTableViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 7/4/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    
    var item : Item?
    @IBOutlet weak var addImageButton: UIButton!
    let library = Library.shared
    var image : UIImage? {
        didSet {
            self.rememberedEditedImage = image
        }
    }
    
    private var category : String?
    @IBOutlet weak var imageView: UIImageView!
    
    private var rememberedEditedDetailsText : String?
    private var rememberedEditedImage : UIImage?
    
    //MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.rememberedEditedDetailsText = self.detailsTextField.text
    }
    
    //MARK: @IBActions
    @IBAction func saveNewItem(sender: UIBarButtonItem) {
        if let newItem = self.nameTextField.text {
            if newItem != "" {
                if let selectedCategory = self.category {
                    item = Item(name: newItem, category: selectedCategory)
                } else {
                    item = Item(name: newItem, category: "None")
                }
                item!.isInList = true
                item!.isCompleted = false
                item!.numOfPurchaces = 0
                item!.detailsText = detailsTextField.text
                item!.image = self.image
                
                library.editDetails(item!)
                library.add(item!)
                library.saveObjects()
            }
        }
        
        self.nameTextField.text = nil
        self.detailsTextField.text = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func Cancel(sender: UIBarButtonItem) {
        self.rememberedEditedDetailsText = nil
        self.rememberedEditedImage = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView DataSource Methods
    private struct TableViewConstants {
        static let numberOfSections = 3
        static let rowsInSectionOne = 2
        static let rowsInSectionTwo = 12
        static let rowsInSectionThree = 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableViewConstants.numberOfSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Category"
        } else if section == 2 {
            return "Image"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Defaults.UI.blueTransperent
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsBySection = [TableViewConstants.rowsInSectionOne, TableViewConstants.rowsInSectionTwo, TableViewConstants.rowsInSectionThree]
        return rowsBySection[section]
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            self.category = Defaults.allCategories[indexPath.row]
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            self.category = Defaults.allCategories[indexPath.row]
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && (item != nil) {
            return nil
        }
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == PhotoViewController.id {
            if let photoVC = segue.destinationViewController as? PhotoViewController {
                if let safeImage = self.imageView.image {
                    photoVC.image = safeImage
                }
            }
        }
    }
}

//MARK: TextFieldDelegate Methods
extension AddItemTableViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.title = "Save"
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if nameTextField.text == nil || nameTextField.text == "" {
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddItemTableViewController : Setup {
    func setup() {
        self.tableView?.backgroundView = UIImageView(image: UIImage(imageLiteral: "texture1"))
        for item in self.navigationItem.leftBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
        for item in self.navigationItem.rightBarButtonItems! {
            item.tintColor = Defaults.UI.blueSolid
        }
        
        if item != nil {
            self.nameTextField.enabled = false
            self.nameTextField.text = item?.name
            if self.rememberedEditedDetailsText != nil {
                self.detailsTextField.text = self.rememberedEditedDetailsText
            } else {
                self.detailsTextField.text = item?.detailsText
            }
            
            self.category = item?.category
            
            if self.rememberedEditedImage != nil {
                self.imageView?.image = self.rememberedEditedImage
            } else {
                self.imageView?.image = item?.image
            }
            
        } else {
            self.nameTextField.enabled = true
        }
        self.tableView.reloadData()
    }
    
    func setupAppearance() {
        self.navigationItem.rightBarButtonItem?.title = "Done"
        self.addImageButton?.layer.cornerRadius = 3.0
    }
    
}

