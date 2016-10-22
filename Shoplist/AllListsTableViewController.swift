//
//  TextTableViewController.swift
//  Shoplist
//
//  Created by Olesia Kalashnik on 10/21/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController, UITextFieldDelegate {
    
    var data : [List]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data == nil {
            data = [List(items: [Item](), name: "New List")]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllListsCell", for: indexPath)
        if indexPath.row < data.count {
            cell.textLabel?.text = data[indexPath.row].name
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        } else {
            let newListTextField = UITextField(frame: CGRect(origin: CGPoint(x: 16, y: cell.contentView.bounds.minY), size: CGSize(width: cell.contentView.bounds.width - 16.0, height: cell.contentView.bounds.height)))
            newListTextField.placeholder = "❍"
            newListTextField.delegate = self
            cell.addSubview(newListTextField)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text {
            data.append(List(items: [Item](), name: name))
        }
        resignFirstResponder()
        tableView.reloadData()
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let name = textField.text {
//            data.append(List(items: [Item](), name: name))
//        }
//        resignFirstResponder()
//        tableView.reloadData()
//    }
    
    
}
