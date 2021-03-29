import Foundation
import UIKit

class TableViewHelper {

    class func EmptyMessage(message:String, viewController:UITableView) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "SystemBold", size: 15)
        messageLabel.sizeToFit()

        viewController.backgroundView = messageLabel
        viewController.separatorStyle = .none
    }
}


