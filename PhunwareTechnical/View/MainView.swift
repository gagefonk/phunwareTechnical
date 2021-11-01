
import UIKit

class MainView: UIViewController {
    
    //MARK: - Declare Variables
    
    //create mainViewVM
    let mainViewVM = MainViewVM()
    //indicator
    var indicator = UIActivityIndicatorView()
    //refresh control
    private let refreshControl = UIRefreshControl()
    //alerts
    let alerts = NotificationUtility()
    
    //collection view
    var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "customCell")
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    //MARK: - View Load

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //navbar
        self.navigationItem.title = "Phun App"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //add views
        view.addSubview(collectionView)
        
        //set delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        mainViewVM.delegate = self
        
        //refresh control
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        
        //get data
        fetch()
    }
    
    override func viewDidLayoutSubviews() {
        
        //invalidate layout on orientation change
        collectionView.collectionViewLayout.invalidateLayout()
        
        //contraints
        layoutViews()
        
    }
    
    //MARK: - UI Layout
    
    private func layoutViews() {
        
        //layout collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if let navbar = self.navigationController {
            collectionView.topAnchor.constraint(equalTo: navbar.navigationBar.bottomAnchor).isActive = true
        } else {
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        }
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func getCellWidthForDeviceType() -> CGFloat {
        
        let userDevice = UIDevice.current
        var frameWidth: CGFloat {
            if userDevice.orientation.isLandscape {
                return UIScreen.main.bounds.size.height
                
            } else {
                return UIScreen.main.bounds.width
                
            }
        }
        
        
        if userDevice.userInterfaceIdiom == .pad {
            return frameWidth * 0.4
        } else {
            return frameWidth * 0.9
        }
    }
    
    //MARK: - API/Data
    
    //fetch data
    @objc func fetch() {
        
        //end refresh indicator
        refreshControl.endRefreshing()
        
        
        //try to load data before going to network call
        mainViewVM.loadData {
            
            //start indicator
            activityIndicatorStart()
            
            if mainViewVM.displayData.isEmpty {
                mainViewVM.fetchEventData {
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.indicator.hidesWhenStopped = true
                        self.mainViewVM.saveData()
                        self.collectionView.reloadData()
                    }
                }
            } else {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.collectionView.reloadData()
            }
            
        }
    }
    
    // indicator
    func activityIndicatorStart() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .large
        indicator.center = self.view.center
        view.addSubview(indicator)
        indicator.startAnimating()
    }


}

extension MainView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, APINetworkError {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return mainViewVM.displayData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! MyCell
        let event = mainViewVM.displayData[indexPath.item]
        cell.configureCell(event: event)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = mainViewVM.displayData[indexPath.item]
        let detailView = DetailView(event: event)
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //get dimensions for phone/pad
        let width = getCellWidthForDeviceType()
        let itemSize = CGSize(width: width, height: 212)

        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let screenWidth = UIScreen.main.bounds.width
        let left = screenWidth * 0.05
        let right = screenWidth * 0.05
        let inset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        
        return inset
    }
    
    func displayNetworkError() {
        
        DispatchQueue.main.async {
            let alert = self.alerts.displayAlert()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

