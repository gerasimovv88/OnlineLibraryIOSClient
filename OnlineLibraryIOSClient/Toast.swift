import UIKit

public class Toast {
    private func showAlert(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    public func showPositiveMessage(message: String) -> UIAlertController {
        return showAlert(title: "Successful", message: message)
    }
    
    public func showNegativeMessage(message: String) -> UIAlertController {
        return showAlert(title: "Error", message: message)
    }
}
