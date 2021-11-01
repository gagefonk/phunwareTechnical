
import Foundation
import UIKit

class API {
    
    func getEventData(completion: @escaping ([APIEvent]?, Error?) -> Void) {
        
        let baseURL = "https://raw.githubusercontent.com/phunware-services/dev-interview-homework/master/feed.json"
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "get"
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            guard let data = data else {
                completion(nil, err)
                return
            }
            do {
                let decoder = JSONDecoder()
                let codeableData = try decoder.decode([APIEvent].self, from: data)
                completion(codeableData, nil)

            }
            catch let parsingError {
                completion(nil, parsingError)
            }
        }.resume()
    }
    
    func getImage(baseURL: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15)
        request.httpMethod = "get"
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            guard let data = data else {
                print(err?.localizedDescription)
                return
            }
            if let image = UIImage(data: data){
                completion(image)
            } else {
                print("failed to get image")
            }
        }.resume()
    }
}
