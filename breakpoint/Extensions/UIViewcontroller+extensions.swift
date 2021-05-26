//
//  UIViewcontroller+extensions.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 23.05.21.
//
import UIKit.UIViewController

extension UIViewController {
    func setRoot(_ controller: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.makeKeyAndVisible()
            window.rootViewController = controller
        }
    }
}
