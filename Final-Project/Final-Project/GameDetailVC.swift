//
//  GameDetailVC.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 30.05.2021.
//

import UIKit
import CoreApi

protocol GameDetailWishDelegate: AnyObject {
    func refreshCollectionView()
}

class GameDetailVC: UIViewController {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var metacriticViewContainer: UIView!
    @IBOutlet weak var metacriticLabel: UILabel!
    @IBOutlet weak var descriptionsContainerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var informationContainerView: UIView!
    @IBOutlet weak var informationTableView: UITableView!
    @IBOutlet weak var redditView: UIView!
    @IBOutlet weak var redditLabel: UILabel!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var websiteLabel: UILabel!
    
    let viewsCornerRadius: CGFloat = 8
    let metacriticLabelCornerRadius: CGFloat = 4
    
    let gameDetailNetworkManager: NetworkManager<GameDetailEndpointItem> = NetworkManager()
    private var shouldFetchGame: Bool = true
    private var detailDict: [String: String] = [:]
    private var wishListDict: [String:[String]] = [:]
    var id: Int = 1
    var gameDetail: GameDetailResponse?
    var isWished: Bool = false
    weak var delegate: GameDetailWishDelegate?
    lazy var navigationBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem()
        button = .init(image: #imageLiteral(resourceName: "WishlistDeselected"), style: .done, target: self, action: #selector(self.wishListButtonTapped(sender:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let wishListData = GamesVC.userDefaults.dictionary(forKey: "WishList") as? [String:[String]] {
            wishListDict = wishListData
            }
        fetchGameDetail(query: id)
        setupUI()
        navigationControllerConfig()
        gestureConfig()
    }
    
    private func setupUI() {
        radiusConfig()
        colorConfig()
        metacriticViewContainer.layer.borderWidth = 0.5
        metacriticViewContainer.layer.borderColor = UIColor.blackThree.cgColor
    }
    
    func configure(gameDetail: GameDetailResponse) {
        gameNameLabel.text = gameDetail.name
        metacriticLabel.text = "\(gameDetail.metacritic ?? 0)"
        descriptionLabel.text = gameDetail.descriptionRaw
        prepareGameImage(with: gameDetail.backgroundImage)
        if gameDetail.metacritic ?? 0 <= 100 && gameDetail.metacritic ?? 0 > 75 {
            metacriticLabel.textColor = UIColor.apple
            metacriticViewContainer.layer.borderColor = UIColor.apple.cgColor
        } else if gameDetail.metacritic ?? 0  <= 75 && gameDetail.metacritic ?? 0 > 50 {
            metacriticLabel.textColor = UIColor.orange
            metacriticViewContainer.layer.borderColor = UIColor.orange.cgColor
        } else if gameDetail.metacritic ?? 0 <= 50 && gameDetail.metacritic ?? 0 >= 0 {
            metacriticLabel.textColor = UIColor.red
            metacriticViewContainer.layer.borderColor = UIColor.red.cgColor
        }
        if let release = gameDetail.released {
            detailDict["Release Date:"] = convertDate(date: release)
        }
        if let playtime = gameDetail.playtime {
            detailDict["Play Time:"] = "\(playtime) hours"
        }
        if let genres = gameDetail.genres {
            let joined = genres.map { $0.name! }.joined(separator: ", ")
            detailDict["Genres:"] = joined
        }
        if let publishers = gameDetail.publishers {
            let joined = publishers.map { $0.name! }.joined(separator: ", ")
            detailDict["Publishers:"] = joined
        }
        navigationBarButton.tintColor = .white
        changeColorOfWishListButton(gameDetail)
        viewShowable()
    }
    
    private func changeColorOfWishListButton(_ gameDetail: GameDetailResponse) {
        if let wishListData = UserDefaults.standard.dictionary(forKey: "WishList") as? [String:[String]] {
          for item in wishListData {
            if let id = gameDetail.id {
              if item.key == "\(id)" {
                navigationBarButton.tintColor = .apple
              }
            }
          }
        }
      }
    
    @objc func wishListButtonTapped(sender: UIBarButtonItem) {
        if let id = gameDetail?.id {
          if navigationBarButton.tintColor == UIColor.white {
            wishListDict["\(id)"] = [gameDetail?.name ?? "", gameDetail?.backgroundImage ?? ""]
            GamesVC.userDefaults.set(wishListDict, forKey:"WishList")
            delegate?.refreshCollectionView()
            navigationBarButton.tintColor = UIColor.apple
          } else {
            wishListDict.removeValue(forKey: "\(id)")
            GamesVC.userDefaults.set(wishListDict, forKey:"WishList")
            delegate?.refreshCollectionView()
            navigationBarButton.tintColor = UIColor.white
          }
        }
      }

    @objc
    func redditLink(tapGesture: UITapGestureRecognizer) {
        UIApplication.shared.open(URL(string: gameDetail?.redditURL ?? "")! as URL, options: [:], completionHandler: nil)
    }
    
    @objc
    func websiteLink(tapGesture: UITapGestureRecognizer) {
        UIApplication.shared.open(URL(string: gameDetail?.website ?? "")! as URL, options: [:], completionHandler: nil)
    }
    
    @objc
    func tapLabel(tapGesture: UITapGestureRecognizer) {
        descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == 0 ? 4 : 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       animations: {
                        self.view.layoutIfNeeded()
                       }, completion: nil)
    }

    private func viewShowable() {
        if gameDetail?.redditURL != nil {
            redditView.isHidden = false
        } else {
            redditView.isHidden = true
        }
        if gameDetail?.website != nil {
            websiteView.isHidden = false
        } else {
            websiteView.isHidden = true
        }
    }
    
    private func prepareGameImage(with urlString: String?) {
        if let imageUrlString = urlString, let url = URL(string: imageUrlString) {
            gameImageView.sd_setImage(with: url)
        }
    }

    private func convertDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "MMM d, yyyy"
        let date: Date? = dateFormatterGet.date(from: "2018-02-16")
        return dateFormatterSet.string(from: date!)
    }
    
    //MARK: - Configurations
    private func gestureConfig() {
        let redditGesture = UITapGestureRecognizer(target: self, action: #selector(redditLink(tapGesture:)))
        redditGesture.numberOfTapsRequired = 1
        redditGesture.numberOfTouchesRequired = 1
        let websiteGesture = UITapGestureRecognizer(target: self, action: #selector(websiteLink(tapGesture:)))
        websiteGesture.numberOfTapsRequired = 1
        websiteGesture.numberOfTouchesRequired = 1
        let labelGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(tapGesture:)))
        labelGesture.numberOfTapsRequired = 1
        labelGesture.numberOfTouchesRequired = 1
        
        redditView.addGestureRecognizer(redditGesture)
        redditView.isUserInteractionEnabled = true
        websiteView.addGestureRecognizer(websiteGesture)
        websiteView.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(labelGesture)
        descriptionLabel.isUserInteractionEnabled = true
    }
    
    private func navigationControllerConfig() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .blackThree
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Game Detail"
        navigationItem.rightBarButtonItem = navigationBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func radiusConfig() {
        metacriticViewContainer.layer.cornerRadius = metacriticLabelCornerRadius
        descriptionsContainerView.layer.cornerRadius = viewsCornerRadius
        informationContainerView.layer.cornerRadius = viewsCornerRadius
        redditView.layer.cornerRadius = viewsCornerRadius
        websiteView.layer.cornerRadius = viewsCornerRadius
    }
    
    private func colorConfig() {
        gameNameLabel.textColor = .white
        descriptionLabel.textColor = .white50
        descriptionsContainerView.backgroundColor = .blackThree
        informationContainerView.backgroundColor = .blackThree
        redditView.backgroundColor = .blackThree
        websiteView.backgroundColor = .blackThree
    }

    private func tableViewsConfig() {
        informationTableView.dataSource = self
        informationTableView.delegate = self
        let nib = UINib(nibName: "GameCardTableViewCell", bundle: nil)
        informationTableView.register(nib, forCellReuseIdentifier: "cardCell")
        //informationTableView.tableFooterView = UIView()
    }
    
    //MARK: - Fetch Response
    private func fetchGameDetail(query: Int) {
        gameDetailNetworkManager.request(endpoint: .gameId(query: query), type: GameDetailResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.gameDetail = response
                self?.configure(gameDetail: response)
                self?.tableViewsConfig()
                print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

//MARK: - TableView DataSource & Delegate
extension GameDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! GameCardTableViewCell
        cell.selectionStyle = .none
        
        let title = Array(detailDict.keys)[indexPath.row]
        let value = Array(detailDict.values)[indexPath.row]
        cell.configure(title: title, detail: value)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
    
}
