//
//  WishlistViewController.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 25.05.2021.
//

import UIKit

class WishlistVC: UIViewController {
    
    @IBOutlet weak var wishListCollectionView: UICollectionView!
    private var wishListDict: [String:[String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerConfig()
        tabBarConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let wishListData = GamesVC.userDefaults.dictionary(forKey: "WishList") as? [String:[String]] {
            wishListDict = wishListData
            print("\(wishListDict)")
            }
        wishListCollectionViewConfig()
    }
    
    @objc func wishListButtonTapped(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        wishListDict.removeValue(forKey: "\(wishListDict[indexPath.row].key)")
        GamesVC.userDefaults.set(wishListDict, forKey:"WishList")
        wishListCollectionView.reloadData()
    }
    
    //MARK: - Configurations
    private func wishListCollectionViewConfig() {
        wishListCollectionView.delegate = self
        wishListCollectionView.dataSource = self
        wishListCollectionView.register(cellType: GameListSmallCardCollectionViewCell.self)
        wishListCollectionView.backgroundColor = .black
        wishListCollectionView.reloadData()
    }
    
    private func navigationControllerConfig() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .blackThree
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Wishlist"
    }
    
    private func tabBarConfig() {
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.backgroundColor = .blackThree
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundImage = UIImage()
    }
}

//MARK: - Collection View DataSource
extension WishlistVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if wishListDict.count == 0 {
            wishListCollectionView.setEmptyMessage("No wishlisted game has been found")
        } else {
            wishListCollectionView.restore()
        }
        return wishListDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let smallCardCell = collectionView.dequeCell(cellType: GameListSmallCardCollectionViewCell.self, indexPath: indexPath)
        let title = Array(wishListDict.keys)[indexPath.row]
        let value = Array(wishListDict.values)[indexPath.row]
        smallCardCell.configure(id: (Int(title) ?? 0), name: value[0], image: value[1])
        smallCardCell.wishlistButton.tag = indexPath.item
        smallCardCell.wishlistButton.addTarget(self, action: #selector(wishListButtonTapped), for: .touchUpInside)
        return smallCardCell
    }
}

//MARK: - Collection View Delegate
extension WishlistVC: UICollectionViewDelegate {
    
}

//MARK: - Collection View DelegateFlowLayout
extension WishlistVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let smallCardSize = CGSize(width: (collectionView.frame.width - 48) / 2, height: 243)
        return smallCardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
