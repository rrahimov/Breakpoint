//
//  AuthVC.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 24.04.21.
//

import UIKit

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
