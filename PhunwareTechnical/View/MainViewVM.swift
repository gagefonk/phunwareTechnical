
import UIKit
import CoreData

protocol APINetworkError: AnyObject {
    func displayNetworkError()
}

class MainViewVM {
    
    let api = API()
    var displayData: [Event] = []
    let dispatchGroup = DispatchGroup()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate: APINetworkError?
    
    func fetchEventData(completion: @escaping () -> Void) {
        api.getEventData { events, err  in
            if err != nil {
                completion()
                self.delegate?.displayNetworkError()
            }
            if let events = events {
                
                events.forEach { apiEvent in
                    self.dispatchGroup.enter()
                    self.formatDisplayData(apiEvent: apiEvent)
                    self.dispatchGroup.leave()
                }
                self.dispatchGroup.notify(queue: .main) {
                    completion()
                }
            }
        }
    }
    
    private func formatEventDates(dateString: String?) -> String {
        
        //string to date
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: dateString!) else {
            return "Date Unavailable"
        }
        
        //get date
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let formatDate = dateFormatter.string(from: date)
        //get time
        dateFormatter.dateFormat = "h:mm a"
        let formateTime = dateFormatter.string(from: date)
        
        return "\(formatDate) at \(formateTime)"
    }
    
    func getImageFromURLS(url: String?) -> UIImage? {
        
        guard let baseURL = url else { return nil }
        guard let imageURL = URL(string: baseURL) else { return nil }
        if let data = try? Data(contentsOf: imageURL) {
            return UIImage(data: data)!
        } else {
            return nil
        }
        
    }
    
    private func formatDisplayData(apiEvent: APIEvent) {
        
        let placeholderImage = UIImage(named: "placeholder_nomoon")
        let title = apiEvent.title ?? "Missing Title"
        let description = apiEvent.description ?? "Missing Description"
        let date = formatEventDates(dateString: apiEvent.date)
        let image = getImageFromURLS(url: apiEvent.image) ?? placeholderImage
        let location = "\(apiEvent.locationline1 ?? "Missing Location"), \(apiEvent.locationline2 ?? "Missing Location")"
        let event = Event(description: description, title: title, date: date, location: location, image: image!)
        displayData.append(event)
    }
    
    private func formatDisplayData(eventData: EventData) {
        
        let placeholderImage = UIImage(named: "placeholder_nomoon")
        let title = eventData.eventTitle ?? "Missing Title"
        let description = eventData.eventDescription ?? "Missing Description"
        let date = eventData.eventDate ?? "Date Unavailable"
        let image = UIImage(data: eventData.eventImage!) ?? placeholderImage
        let location = eventData.eventLocation ?? "Location Unavailable"
        let event = Event(description: description, title: title, date: date, location: location, image: image!)
        displayData.append(event)
    }
    
    func loadData(completion: ()->Void) {
        
        let request: NSFetchRequest<EventData> = EventData.fetchRequest()
        var events: [EventData] = []
        
        do {
            events = try context.fetch(request)
            if !events.isEmpty {
                events.forEach { event in
                    formatDisplayData(eventData: event)
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        completion()
    }
    
    func saveData() {
        
        var eventData: [EventData] = []
        
        if !displayData.isEmpty {
            displayData.forEach { event in
                let item = EventData(context: context)
                item.eventTitle = event.title
                item.eventDate = event.date
                item.eventLocation = event.location
                item.eventDescription = event.description
                item.eventImage = event.image.pngData()
                eventData.append(item)
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
        
    }
    
    
}
