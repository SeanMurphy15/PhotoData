//
//  ViewController.swift
//  PhotoData
//
//  Created by Sean Murphy on 9/15/16.
//  Copyright © 2016 Sean Murphy. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

	let databaseRef = FIRDatabase.database().reference()

	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		emailTextField.text = "sdmalias@gmail.com"
		passwordTextField.text = "1234567"
		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	@IBAction func loginButtonPressed(sender: AnyObject) {
		FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in

			if let user = user {

				let userData : [String: String] = ["albums": "12345", "photos": "12345"]
				self.databaseRef.child("users").child(user.uid).setValue(userData)

			  } else {
			}
		}
		
	}
	
	
}

