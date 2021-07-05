 //
//  GroupCell.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 03.07.21.
//

import UIKit

class GroupCell: UITableViewCell {
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescLbl: UILabel!
    @IBOutlet weak var memberCountLbl: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLbl.text = title
        self.groupDescLbl.text = description
        self.memberCountLbl.text = "\(memberCount) members."
    }
}
