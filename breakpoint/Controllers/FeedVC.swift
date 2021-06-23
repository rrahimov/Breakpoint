//
//  FeedVC.swift
//  breakpoint
//
//  Created by Ruhullah Rahimov on 29.04.21.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messagesArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllFeedMessages { returnedMessagesArray in
            self.messagesArray = returnedMessagesArray.reversed()
            self.tableView.reloadData()
        }
        print(messagesArray)
    }
    

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return UITableViewCell() }
        let image = UIImage(named: "defaultProfileImage") ?? UIImage()
        let message = messagesArray[indexPath.row]
        DataService.instance.getUserName(forUID: message.senderId) { returnedUsername in
            cell.configureCell(profileImage: image, email: returnedUsername, content: message.content)
        }
        
        return cell
    }
}
