//
//  Copyright © 2024 Emarsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var messages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        showMessage("Login clicked!")
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        showMessage("Logout clicked!")
    }
    
    @IBAction func triggerCustomEventClicked(_ sender: Any) {
        showMessage("Custom event clicked!")
    }
    
    @IBAction func fetchInboxMessagesClicked(_ sender: Any) {
        messages = ["Message 1", "Message 2", "Message 3"]
        tableView.reloadData()
        showMessage("Inbox messages fetched!")
    }
    
    @IBAction func addInboxTagClicked(_ sender: Any) {
        showMessage("Add inbox tag clicked!")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
    
    private func showMessage(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}

