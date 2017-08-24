import UIKit

public class Toast {
    private func showAlert(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    public func showPositiveMessage(message: String) -> UIAlertController {
        return showAlert(title: NSLocalizedString("Successful", comment: ""), message: message)
    }
    
    public func showNegativeMessage(message: String) -> UIAlertController {
        return showAlert(title: NSLocalizedString("Error", comment: ""), message: message)
    }
}
