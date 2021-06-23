//
//  AuthVC.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 24.04.21.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signInEmailBtnPressed(_ sender: Any) {
        let LoginVC = storyboard?.instantiateViewController(identifier: "LoginVC")
        present(LoginVC!, animated: true, completion: nil)
    }
    @IBAction func signInGoogleBtnPressed(_ sender: Any) {
    }
    @IBAction func signInFacebookBtnPressed(_ sender: Any) {
    }
    

}
