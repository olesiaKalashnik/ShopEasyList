//
//  TextTableViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 10/21/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController {
    
    var data : [List]! = CollectionOfLists.shared.items {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedList : List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func saveNewList(_ textField: UITextField) {
        if let name = textField.text {
            if name.characters.count > 0 {
                let newList = List(items: [Item](), name: name)
                data.append(newList)
                CollectionOfLists.shared.add(list: newList)
                CollectionOfLists.shared.saveObjects()
                textField.isEnabled = false
                resignFirstResponder()
                tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllListsCell", for: indexPath)
        if indexPath.row < data.count {
            cell.textLabel?.text = data[indexPath.row].name
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        } else {
            let newListTextField = UITextField(frame: CGRect(origin: CGPoint(x: 16, y: cell.contentView.bounds.minY), size: CGSize(width: cell.contentView.bounds.width - 16.0, height: cell.contentView.bounds.height)))
            newListTextField.placeholder = "＋"
            newListTextField.delegate = self
            cell.addSubview(newListTextField)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedList = data[indexPath.row]
        return indexPath
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "List" {
            if let destinationVC = segue.destination as? ListViewController {
                if let selectedList = self.selectedList {
                    destinationVC.currentList = selectedList
                }
            }
        }
    }
}

//MARK: - UITextFieldDelegate methods

extension AllListsTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveNewList(textField)
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = nil
        return true
    }
    
}




