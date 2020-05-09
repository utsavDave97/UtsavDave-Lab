//
//  AddViewController.swift
//  Lab
//
//  Created by Utsav Dave on 2020-05-08.
//  Copyright © 2020 Utsav Dave. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class AddViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: MDCOutlinedTextField!
    @IBOutlet weak var locationTextField: MDCOutlinedTextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    let realm = try! Realm()
    var labData : Lab?
    static var isEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the User Interface
        setUpUI()
        
        // Add a tap gesture on entire view which would dismiss keyboard
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // add the tapGesture to the view
        view.addGestureRecognizer(tapGesture)
    }
    
    func setUpUI()
    {
        //Hide the error label when the view shows up
        errorLabel.alpha = 0
        
        /*
         Setup name text field
         If the labData is available than assign it the name else keep it empty
         */
       nameTextField.text = labData?.name ?? ""
       nameTextField.label.text = "Lab Name"
       nameTextField.placeholder = "Please enter lab name"
       nameTextField.sizeToFit()

       /*
       Setup location text field
       If the labData is available than assign it the location else keep it empty
       */
       locationTextField.text = labData?.location ?? ""
       locationTextField.label.text = "Lab Location"
       locationTextField.placeholder = "Please enter lab location"
       locationTextField.sizeToFit()
       
       /*
       Setup name button. Add corner radius and shadows
       If the labData is available than assign it the name else keep it empty
       */
        addButton.setTitle(isEditing ? "Update Lab" : "Add Lab",for: .normal)
       addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
       addButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
       addButton.layer.shadowOpacity = 1.0
       addButton.layer.shadowRadius = 0.0
       addButton.layer.masksToBounds = false
       addButton.layer.cornerRadius = 4.0
        
       /*
       Setup name text field
       If the labData is available than assign it the date else keep today's date
       */
       datePicker.setDate(labData?.date ?? Date(), animated: true)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func addLabTapped(_ sender: Any)
    {
        //Validate the text fields
        let error = validateFields()
        
        if error != nil
        {
            //Show the error as there is textfield might be empty
            showError(error)
        }
        else
        {
            //Create cleaned versions of the text fields
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let location = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let date = datePicker.date
            
            // Check if editing or saving a new object
            if isEditing == true {
                // Update the existing object
                 try? realm.write ({
                    labData?.name = name
                    labData?.location = location
                    labData?.date = date
                       })
            }
            else if isEditing == false
            {
                // Create a new object
                // Create a lab with the values
                let lab = Lab.createLab(withName: name, withLocation: location,withDate: date)
                
                try! realm.write{
                    realm.add(lab)
                }
                
                nameTextField.text = ""
                locationTextField.text = ""
                datePicker.setDate(Date(), animated: true)
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    // This function checks the validity of the text fields
    func validateFields() -> String?
    {
       //Check all the fields are filled in
       if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
       {
           return "Please fill in all fields."
       }
       
       return nil
    }
       
    //This function makes the errorLabel's visibility on or off
    func showError(_ error: String?)
    {
       errorLabel.text = error!
       errorLabel.alpha = 1
    }
    
}
