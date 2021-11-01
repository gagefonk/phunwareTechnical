
import UIKit

struct APIEvent: Codable {
    
    let description: String?
    let title: String?
    let timestamp: String?
    let image: String?
    let date: String?
    let locationline1: String?
    let locationline2: String?
    
}

struct Event {
    let description: String
    let title: String
    let date: String
    let location: String
    var image: UIImage
}
