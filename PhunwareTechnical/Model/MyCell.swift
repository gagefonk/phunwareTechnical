
import UIKit

class MyCell: UICollectionViewCell {
    
    static let reuseIdentifier = "customCell"
    
    //create views
    private var backgroundImage: UIImageView = {
        let bgImage = UIImageView()
        
        return bgImage
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15.0)
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 28.0)
        
        return label
    }()
    
    private let locLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15.0)
        
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //add views
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locLabel)
        contentView.addSubview(descLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //add constraints
        
        //date
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        //title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        //loc
        locLabel.translatesAutoresizingMaskIntoConstraints = false
        locLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        locLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
        locLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
        locLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        //desc
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraint(equalTo: locLabel.bottomAnchor, constant: 8).isActive = true
        descLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
        descLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
    }
    
    func configureCell(event: Event) {
        let imageView = UIImageView(image: event.image)
        imageView.layer.opacity = 0.5
        backgroundColor = .black
        backgroundView = imageView
        dateLabel.text = event.date
        titleLabel.text = event.title
        locLabel.text = event.location
        descLabel.text = event.description
    }
    
}
