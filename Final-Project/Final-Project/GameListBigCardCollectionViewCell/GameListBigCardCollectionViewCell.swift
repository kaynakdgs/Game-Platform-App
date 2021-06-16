//
//  GameListBigCardCollectionViewCell.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 25.05.2021.
//

import UIKit
import SDWebImage

class GameListBigCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var descriptionViewContainer: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var metacriticScoreView: UIView!
    @IBOutlet weak var metacriticScoreLabel: UILabel!
    @IBOutlet weak var gameCardTableView: UITableView!
    @IBOutlet weak var platformTagCollectionView: UICollectionView!
    
    let cellCornerRadius: CGFloat = 8
    let wishlistButtonCornerRadius: CGFloat = 4
    let metacriticScoreLabelCornerRadius: CGFloat = 4
    
    var parentPlatformList: [ParentPlatform]?
    private var detailDictionary: [String: String] = [:]
    var platforms: [Result]? = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        tableViewsConfig()
        platformTagCollectionViewConfig()
        wishListButtonConfig()
    }
    
    private func setupCell() {
        cellRadiusConfig()
        cellBackgroundColorsConfig()
        metacriticScoreView.layer.borderWidth = 0.5
        metacriticScoreView.layer.borderColor = UIColor.blackThree.cgColor
        gameNameLabel.textColor = .white
        wishlistButton.backgroundColor = .wishGrey
    }
    
    func configure(game: Game) {
        gameNameLabel.text = game.name
        prepareGameImage(with: game.backgroundImage)
        parentPlatformList = game.parentPlatforms
        metacriticScoreLabel.text = "\(game.metacritic ?? 0)"
        if game.metacritic ?? 0 <= 100 && game.metacritic ?? 0 > 75 {
            metacriticScoreLabel.textColor = UIColor.apple
            metacriticScoreView.layer.borderColor = UIColor.apple.cgColor
        } else if game.metacritic ?? 0  <= 75 && game.metacritic ?? 0 > 50 {
            metacriticScoreLabel.textColor = UIColor.orange
            metacriticScoreView.layer.borderColor = UIColor.orange.cgColor
        } else if game.metacritic ?? 0 <= 50 && game.metacritic ?? 0 >= 0 {
            metacriticScoreLabel.textColor = UIColor.red
            metacriticScoreView.layer.borderColor = UIColor.red.cgColor
        }
        if let release = game.released {
            detailDictionary["Release Date:"] = convertDate(date: release)
        }
        if let genres = game.genres {
            let joined = genres.map { $0.name! }.joined(separator: ", ")
            detailDictionary["Genres:"] = joined
        }
        if let playtime = game.playtime {
            detailDictionary["Play Time:"] = "\(playtime) hours"
        }
        wishlistButton.backgroundColor = .wishGrey
        changeColorOfWishListButton(game)
    }
    
    private func changeColorOfWishListButton(_ gamesList: Game) {
        if let wishListData = UserDefaults.standard.dictionary(forKey: "WishList") as? [String:[String]] {
          for item in wishListData {
            if let id = gamesList.id {
              if item.key == "\(id)" {
                wishlistButton.backgroundColor = .apple
              }
            }
          }
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
    
    private func prepareGameImage(with urlString: String?) {
        if let imageUrlString = urlString, let url = URL(string: imageUrlString) {
            gameImageView.sd_setImage(with: url)
        }
    }
    
    //MARK: - Configurations
    private func wishListButtonConfig() {
        wishlistButton.setImage(UIImage(named: "WishlistDeselected"), for: .normal)
        wishlistButton.setImage(UIImage(named: "WishlistDeselected"), for: .selected)
    }
    
    private func cellRadiusConfig() {
        containerView.layer.cornerRadius = cellCornerRadius
        wishlistButton.layer.cornerRadius = wishlistButtonCornerRadius
        metacriticScoreView.layer.cornerRadius = metacriticScoreLabelCornerRadius
        containerView.layer.masksToBounds = true
    }
    
    private func cellBackgroundColorsConfig() {
        containerView.backgroundColor = .blackThree
        topContainerView.backgroundColor = .blackThree
        metacriticScoreView.backgroundColor = .blackThree
    }
    
    private func tableViewsConfig() {
        gameCardTableView.dataSource = self
        gameCardTableView.delegate = self
        let nib = UINib(nibName: "GameCardTableViewCell", bundle: nil)
        gameCardTableView.register(nib, forCellReuseIdentifier: "cardCell")
        //gameCardTableView.tableFooterView = UIView()
    }
    
    private func platformTagCollectionViewConfig() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        platformTagCollectionView.isScrollEnabled = false
        platformTagCollectionView.frame = .zero
        platformTagCollectionView.collectionViewLayout = layout
        platformTagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        platformTagCollectionView.dataSource = self
        platformTagCollectionView.delegate = self
        platformTagCollectionView.register(cellType: GameCardPlatformCell.self)
        platformTagCollectionView.backgroundColor = .clear
    }
    
}

//MARK: - UITableView DataSource & Delegate
extension GameListBigCardCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! GameCardTableViewCell
        cell.selectionStyle = .none
        
        let title = Array(detailDictionary.keys)[indexPath.row]
        let value = Array(detailDictionary.values)[indexPath.row]
        cell.configure(title: title, detail: value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
}

//MARK: - CollectionView DataSource
extension GameListBigCardCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if parentPlatformList?.count ?? .zero > 3 {
            return 4
        } else {
            return parentPlatformList?.count ?? .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let platformTagCell = collectionView.dequeCell(cellType: GameCardPlatformCell.self, indexPath: indexPath)
        
        if indexPath.item == 3 {
            let maxTag = (parentPlatformList?.count ?? .zero) - 3
            platformTagCell.platformTagLabel.text = "+\(maxTag)"
        } else {
            if let platform = parentPlatformList?[indexPath.item].platform {
                platformTagCell.configure(platformTag: platform)
            }
        }
        return platformTagCell
    }
}

//MARK: - CollectionView Delegate
extension GameListBigCardCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
}
