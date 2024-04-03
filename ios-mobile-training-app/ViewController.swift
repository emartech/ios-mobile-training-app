//
//  Copyright © 2024 Emarsys. All rights reserved.
//

import UIKit
import EmarsysSDK

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var messages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        Emarsys.setContact(contactFieldId: 100010824, contactFieldValue: "ac55b39a2cd7482bb0a6998017cd71de")
        showMessage("Login clicked!")
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        Emarsys.clearContact()
        showMessage("Logout clicked!")
    }
    
    @IBAction func triggerCustomEventClicked(_ sender: Any) {
        Emarsys.trackCustomEvent(eventName: "test_event")
        showMessage("Custom event clicked!")
    }
    
    @IBAction func fetchInboxMessagesClicked(_ sender: Any) {
        messages = ["Message 1", "Message 2", "Message 3"]
        Emarsys.messageInbox.fetchMessages { [weak self] (result, error) in
            self?.messages.removeAll()
            self?.messages = result?.messages.map { message in
                return "\(message.id) | \(message.title) | \(message.tags ?? [])"
            } ?? []
            self?.tableView.reloadData()
            self?.showMessage("Inbox messages fetched!")
        }
    }
    
    @IBAction func addInboxTagClicked(_ sender: Any) {
        Emarsys.messageInbox.addTag(tag: "opened", messageId: "12802360654")
        showMessage("Add inbox tag clicked!")
    }
    
    @IBAction func removeInboxTagClicked(_ sender: Any) {
        Emarsys.messageInbox.removeTag(tag: "opened", messageId: "12802360654")
        showMessage("Remove inbox tag clicked!")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    private func showMessage(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
