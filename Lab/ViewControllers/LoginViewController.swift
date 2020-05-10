//
//  LoginViewController.swift
//  Lab
//
//  Created by Utsav Dave on 2020-05-09.
//  Copyright © 2020 Utsav Dave. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        checkIfUserLoggedIn()
        
        // Do any additional setup after loading the view.
        // Add a tap gesture on entire view which would dismiss keyboard
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        // add the tapGesture to the view
        view.addGestureRecognizer(tapGesture)
    }
    
    // Function to dismiss the keyboard
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func setUpUI()
       {
          //Hide the error label when the view shows up
          errorLabel.alpha = 0
           
          /*
          Setup email text field
          Make the keyboard type of email address
          */
          emailTextField.label.text = "Email"
          emailTextField.placeholder = "Please enter email"
          emailTextField.keyboardType = .emailAddress
          emailTextField.sizeToFit()

          /*
          Setup password text field.
          Make it secure text entry
          */
          passwordTextField.label.text = "Password"
          passwordTextField.isSecureTextEntry = true
          passwordTextField.placeholder = "Please enter password"
          passwordTextField.sizeToFit()
          
          /*
          Setup login button. Add corner radius and shadows
          */
          loginButton.setTitle("Login",for: .normal)
          loginButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
          loginButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
          loginButton.layer.shadowOpacity = 1.0
          loginButton.layer.shadowRadius = 0.0
          loginButton.layer.masksToBounds = false
          loginButton.layer.cornerRadius = 4.0
       }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any)
    {
        // setting the login status to true
        UserDefaults.standard.set(true, forKey: "status")
        transitionToHome()
    }
    
    //Check if user is logged in or not
    private func checkIfUserLoggedIn()
    {
        //If the user is logged in than take the user to home screen directly
        let status = UserDefaults.standard.bool(forKey: "status")
        if(status)
        {
            transitionToHome()
        }
        // Else stay on log in screen
        else
        {
            return
        }
    }
    
    func transitionToHome()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let labVC = storyboard.instantiateViewController(withIdentifier: "labTableVC") as? LabTableViewController {
            self.navigationController?.pushViewController(labVC, animated: true)
        }
    }
}
