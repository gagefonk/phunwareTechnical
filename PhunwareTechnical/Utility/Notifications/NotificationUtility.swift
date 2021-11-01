
import UIKit

struct NotificationUtility {
    
    func displayAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "Unable to perform network call", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        return alert
        
    }
}
