//
//  ViewController.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 24.05.2021.
//

import UIKit
import CoreApi

class GamesVC: UIViewController {
    
    @IBOutlet private weak var gameListCollectionView: UICollectionView!
    let networkManager: NetworkManager<GameEndpointItem> = NetworkManager()
    let platformNetworkManager: NetworkManager<PlatformTagEndpointItem> = NetworkManager()
    let searchNetworkManager: NetworkManager<SearchEndPointItem> = NetworkManager()
    let filterNetworkManager: NetworkManager<FilterEndPointItem> = NetworkManager()
    private var results: [Game]? = []
    private var parentPlatforms: [Result]? = []
    private var nextPage: String = "key=b306e5dd547c4e80840a4afe9a876069&page=1"
    private var search: String = "portal"
    private var filter: String = "1"
    private var filterNextPage: Bool = false
    private var shouldFetchNextPage: Bool = true
    var isBigCard = true
    var searchActive: Bool = false
    private var wishListDict: [String:[String]] = [:]
    static let userDefaults = UserDefaults.standard
    lazy var navigationBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem()
        button = .init(image: #imageLiteral(resourceName: "smallLayoutButton"), style: .done, target: self, action: #selector(self.changeLayoutButton(sender:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let wishListData = GamesVC.userDefaults.dictionary(forKey: "WishList") as? [String:[String]] {
            wishListDict = wishListData
            }
        navigationControllerConfig()
        tabBarConfig()
        searchBarConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchGames(query: nextPage)
        fetchPlatform()
    }
 
    @objc
    func changeLayoutButton(sender: UIBarButtonItem) {
        isBigCard = !isBigCard
        navigationBarButton.image = isBigCard ? #imageLiteral(resourceName: "smallLayoutButton") : #imageLiteral(resourceName: "bigLayoutButton")
        gameListCollectionView.reloadData()
    }
    
    @objc func wishListButtonTapped(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let id = results?[indexPath.row].id {
          if sender.backgroundColor == UIColor.wishGrey {
            wishListDict["\(id)"] = [results?[indexPath.row].name ?? "", results?[indexPath.row].backgroundImage ?? ""]
            GamesVC.userDefaults.set(wishListDict, forKey:"WishList")
            sender.backgroundColor = UIColor.apple
          } else {
            wishListDict.removeValue(forKey: "\(id)")
            GamesVC.userDefaults.set(wishListDict, forKey:"WishList")
            sender.backgroundColor = UIColor.wishGrey
          }
        }
      }
    
//MARK: - Configurations
    private func navigationControllerConfig() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .blackThree
        navigationController?.navigationBar.backgroundColor = .blackThree
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        title = "Games"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = navigationBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.backButtonTitle = "Back"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func searchBarConfig() {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barStyle = .default
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.barTintColor = .blackThree
        searchController.searchBar.backgroundColor = .blackThree
        searchController.searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        navigationItem.searchController = searchController
    }
    
    private func gameCollectionViewConfig() {
        gameListCollectionView.delegate = self
        gameListCollectionView.dataSource = self
        gameListCollectionView.register(cellType: GameListBigCardCollectionViewCell.self)
        gameListCollectionView.register(cellType: GameListSmallCardCollectionViewCell.self)
        gameListCollectionView.register(GameListHeaderCollectionReusableView.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: GameListHeaderCollectionReusableView.identifier)
        gameListCollectionView.backgroundColor = .black
    }
    
    private func tabBarConfig() {
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.backgroundColor = .blackThree
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundImage = UIImage()
    }
    
    //MARK: - Fetch Responses
    private func fetchGames(query: String) {
        networkManager.request(endpoint: .gamepage(query: query), type: GameResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if let results = response.results {
                    if query == "key=b306e5dd547c4e80840a4afe9a876069&page=1" {
                        self?.results = results
                    } else {
                        self?.shouldFetchNextPage = !results.isEmpty
                        self?.results?.append(contentsOf: results)
                    }
                } else {
                    self?.shouldFetchNextPage = false
                }
                self?.nextPage = response.next ?? ""
                self?.gameListCollectionView.reloadData()
                self?.gameCollectionViewConfig()
                print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func fetchPlatform() {
        platformNetworkManager.request(endpoint: .platforms, type: PlatformResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.parentPlatforms = response.results
                print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func searchGame(query: String) {
        searchNetworkManager.request(endpoint: .search(query: query), type: GameResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if let results = response.results {
                    if self?.search == "portal" {
                        self?.results = results
                    } else {
                        self?.shouldFetchNextPage = !results.isEmpty
                        self?.results?.append(contentsOf: results)
                    }
                } else {
                    self?.shouldFetchNextPage = false
                }
                self?.nextPage = response.next ?? ""
                self?.gameListCollectionView.reloadData()
                print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func filterGame(query: String) {
        filterNetworkManager.request(endpoint: .filter(query: query), type: GameResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if let results = response.results {
                    if self?.filter == "1" || self?.filterNextPage == true {
                        self?.results = results
                    } else {
                        self?.shouldFetchNextPage = !results.isEmpty
                        self?.results?.append(contentsOf: results)
                    }
                } else {
                    self?.shouldFetchNextPage = false
                }
                self?.nextPage = response.next ?? ""
                self?.gameListCollectionView.reloadData()
                print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

//MARK: - GameDetailWishDelegate
extension GamesVC: GameDetailWishDelegate {
    func refreshCollectionView() {
        gameListCollectionView.reloadData()
    }
}

//MARK: - FilterGamesDelegate
extension GamesVC: FilterGamesDelegate {
    func refreshFilter(filterId: String) {
        filterNextPage = true
        filter = filterId
        searchGame(query: filter)
    }
    
    func filterGames(filterId: String) {
        filterNextPage = true
        filter = filterId
        filterGame(query: filter)
    }
}

//MARK: - CollectionView DataSource
extension GamesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if results?.count == 0 {
            gameListCollectionView.setEmptyMessage("No game has been found")
        } else {
            gameListCollectionView.restore()
        }
        return results?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isBigCard {
            let bigCardCell = collectionView.dequeCell(cellType: GameListBigCardCollectionViewCell.self, indexPath: indexPath)
            guard let game = results?[indexPath.item] else { return UICollectionViewCell() }
            bigCardCell.configure(game: game)
            bigCardCell.wishlistButton.tag = indexPath.item
            bigCardCell.wishlistButton.addTarget(self, action: #selector(wishListButtonTapped), for: .touchUpInside)
            bigCardCell.platforms = parentPlatforms
            return bigCardCell
        } else {
            let smallCardCell = collectionView.dequeCell(cellType: GameListSmallCardCollectionViewCell.self, indexPath: indexPath)
            guard let game = results?[indexPath.item] else { return UICollectionViewCell() }
            smallCardCell.configure(id: game.id ?? 0, name: game.name ?? "", image: game.backgroundImage ?? "")
            smallCardCell.wishlistButton.tag = indexPath.item
            smallCardCell.wishlistButton.addTarget(self, action: #selector(wishListButtonTapped), for: .touchUpInside)
            return smallCardCell
        }
    }
    //MARK: - CollectionView Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: GameListHeaderCollectionReusableView.identifier,
                                                                     for: indexPath) as! GameListHeaderCollectionReusableView
        header.platforms = parentPlatforms
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width - 16, height: 68)
    }
}

//MARK: - CollectionView Delegate
extension GamesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let games = results else { return }
        if indexPath.item == ((games.count ) - 1), shouldFetchNextPage {
            if let url = URL(string: nextPage) {
                fetchGames(query: url.query ?? "")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gamesStortyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameDetailVc = gamesStortyBoard.instantiateViewController(identifier: "GameDetailVC") as! GameDetailVC
        gameDetailVc.delegate = self
        if let detailedGame = results?[indexPath.item] {
            gameDetailVc.id = detailedGame.id ?? 0
        }
        self.navigationController?.pushViewController(gameDetailVc, animated: true)
        
    }
}

//MARK: - CollectionView DelegateFlowLayout
extension GamesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bigCardSize = CGSize(width: collectionView.frame.width - 32,
                                 height: 360)
        let smallCardSize = CGSize(width: (collectionView.frame.width - 48) / 2,
                                    height: 243)
        
        return isBigCard ? bigCardSize : smallCardSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

// MARK: - SearchBar Delegate
extension GamesVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        searchGame(query: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchGame(query: "")
    }
}
