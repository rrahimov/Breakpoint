//
//  UIViewControllerExt.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 08.07.21.
//

import UIKit

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
    //contstant that's gonna hold the animation:
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dissmissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}
