
import UIKit

class DetailView: UIViewController {
    
    //create variables
    
    var event: Event?
    
    //create views
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 28.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let locLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.opacity = 0.5
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    init(event: Event) {
        super.init(nibName: nil, bundle: nil)
        self.event = event
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up.fill"), style: .done, target: self, action: #selector(share))
        navigationController?.navigationBar.tintColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(locLabel)
        scrollView.addSubview(descLabel)
    }
    
    override func viewDidLayoutSubviews() {
        
        setupLayout()
        populateData()

    }
    
    private func setupLayout() {
        
        //scrollview
        scrollView.frame = view.frame
        
        //bg image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: view.bounds.height/3).isActive = true
        
        //gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = backgroundImageView.frame
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 1.0]
        backgroundImageView.layer.mask = gradient
        
        //date label
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -24).isActive = true
        dateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 212).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -24).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //loc
        locLabel.translatesAutoresizingMaskIntoConstraints = false
        locLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        locLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -24).isActive = true
        locLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36).isActive = true
        locLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //desc
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 24).isActive = true
        descLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -24).isActive = true
        descLabel.topAnchor.constraint(equalTo: locLabel.bottomAnchor, constant: 8).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            
    }
    
    private func populateData() {
        
        //background
        scrollView.backgroundColor = .black
        
        if let event = event {
            backgroundImageView.image = event.image
            dateLabel.text = event.date
            titleLabel.text = event.title
            locLabel.text = event.location
            descLabel.text = event.description
        }
        
    }
    
    @objc private func share() {
    
        guard let sharedEvent = event else { return }
        let item = "\(sharedEvent.title), \(sharedEvent.location), \(sharedEvent.date), \(sharedEvent.description)"
        let activityController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityController.excludedActivityTypes = [.print, .addToReadingList, .airDrop, .addToReadingList, .assignToContact, .copyToPasteboard, .markupAsPDF, .openInIBooks, .postToVimeo, .postToWeibo, .postToFlickr, .postToTwitter, .postToFacebook, .postToTencentWeibo, .saveToCameraRoll]
        self.present(activityController, animated: true)
    }

}
