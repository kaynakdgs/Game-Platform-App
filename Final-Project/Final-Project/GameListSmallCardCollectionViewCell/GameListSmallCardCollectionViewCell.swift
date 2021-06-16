//
//  GameListSmallCardCollectionViewCell.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 26.05.2021.
//

import UIKit

class GameListSmallCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameImageContainer: UIView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var gameNameContainer: UIView!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    let cellCornerRadius: CGFloat = 8
    let wishlistButtonCornerRadius: CGFloat = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        wishListButtonConfig()
    }
    
    private func setupCell() {
        containerView.backgroundColor = .blackThree
        gameNameLabel.textColor = .white
        cellRadiusConfig()
    }
    
    func configure(id: Int, name: String, image: String) {
        gameNameLabel.text = name
        prepareGameImage(with: image)
        wishlistButton.backgroundColor = .wishGrey
        changeColorOfWishListButton(id: id)
    }
    
    private func changeColorOfWishListButton(id: Int?) {
        if let wishListData = UserDefaults.standard.dictionary(forKey: "WishList") as? [String:[String]] {
          for item in wishListData {
            if let id = id {
              if item.key == "\(id)" {
                wishlistButton.backgroundColor = .apple
              }
            }
          }
        }
      }

    private func prepareGameImage(with urlString: String?) {
        if let imageUrlString = urlString, let url = URL(string: imageUrlString) {
            gameImageView.sd_setImage(with: url)
        }
    }
    
    private func wishListButtonConfig() {
        wishlistButton.setImage(UIImage(named: "WishlistDeselected"), for: .normal)
        wishlistButton.setImage(UIImage(named: "WishlistDeselected"), for: .selected)
    }
    
    private func cellRadiusConfig() {
        containerView.layer.cornerRadius = cellCornerRadius
        wishlistButton.layer.cornerRadius = wishlistButtonCornerRadius
        containerView.layer.masksToBounds = true
    }
}
