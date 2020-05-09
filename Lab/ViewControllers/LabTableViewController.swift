//
//  LabTableViewController.swift
//  Lab
//
//  Created by Utsav Dave on 2020-05-08.
//  Copyright © 2020 Utsav Dave. All rights reserved.
//

import UIKit
import RealmSwift

class LabTableViewController: UITableViewController {
    
    // MARK: - Properties
    let realm = try! Realm()
    var labs: Results<Lab>?
    private var labsToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        labs = Lab.all()
        
        self.tableView.reloadData()
        
        // Add right and left bar button items to view controller
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         observe method of Realm would update TableView as soon as the data changes inside Realm Database
         */
        labsToken = labs?.observe({[weak tableView] (changes) in
            tableView?.reloadData()
        })
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let addVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        addVc.isEditing = false

        self.navigationController?.pushViewController(addVc, animated: true)
    }
    
    @objc func logOut()
    {
        UserDefaults.standard.set(false, forKey: "status")
        UserDefaults.standard.synchronize()
        //Take the user back to login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Table view data source
extension LabTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labs?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Assign each cell a lab name and a lab location
        cell.textLabel?.text = labs?[indexPath.item].name
        cell.detailTextLabel?.text = labs?[indexPath.item].location

        // return the cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the reference to AddViewController via its Storyboard ID
        let addVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        
        // Assign labData to current indexpath
        addVc.labData = labs?[indexPath.row]
        
        // When the user clicks on cell, it means they want to view it and edit it
        addVc.isEditing = true
        
        // push the view controller
        self.navigationController?.pushViewController(addVc, animated: true)
        
        // deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // This method is used for swipe actions on each cell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Define the delete action
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            // Delete the row from the data source
            try! self.realm.write {
                // Delete specific cell
                self.realm.delete((self.labs?[indexPath.item])!)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        }
        // Assign the image and background color to swipe action
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor.red
        
        /*
         Get the location of selected cell.
         Remove the spaces in between them.
         Removal of spaces is required as they would be passed as parameter to
         Google Maps url.
         */
        let location = labs?[indexPath.item].location.filter{ !$0.isWhitespace } ?? "Canada"
        
        // Define the locate action
        let locateAction = UIContextualAction(style: .normal, title: "Locate") { (action, view, completion) in
            // Open the URL
            UIApplication.shared.open(URL(string:"https://www.google.com/maps/place/"+location)!,options: [:],completionHandler: nil)
          completion(true)
        }
        // Assign the image and background color to swipe action
        locateAction.image = UIImage(systemName: "location.fill")
        locateAction.backgroundColor = UIColor.blue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, locateAction])
    }
}
