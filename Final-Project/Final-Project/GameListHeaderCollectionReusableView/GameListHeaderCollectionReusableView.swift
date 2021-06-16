//
//  GameListHeaderCollectionReusableView.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 27.05.2021.
//

import UIKit

protocol FilterGamesDelegate: AnyObject {
    func filterGames(filterId: String)
    func refreshFilter(filterId: String)
}

class GameListHeaderCollectionReusableView: UICollectionReusableView {

    static let identifier = "GameListHeaderCollectionReusableView"
    var platforms: [Result]? = []
    weak var delegate: FilterGamesDelegate?
    private let headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(cellType: HeaderCollectionViewCell.self)
        cv.backgroundColor = .black
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerCollectionView)
        headerCollectionViewConfig()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        headerCollectionView.frame = bounds
    }
    
    private func headerCollectionViewConfig() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(cellType: HeaderCollectionViewCell.self)
    }
}

//MARK: - CollectionView DataSource
extension GameListHeaderCollectionReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms?.count ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let platformCell = collectionView.dequeCell(cellType: HeaderCollectionViewCell.self, indexPath: indexPath)
        
        if let platform = platforms?[indexPath.item] {
            platformCell.configure(platformTag: platform)
        }
        
        return platformCell
    }
}

//MARK: - CollectionView Delegate
extension GameListHeaderCollectionReusableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let platformCell = collectionView.cellForItem(at: indexPath)
        if platformCell?.isSelected ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
            let filterId = ""
            delegate?.refreshFilter(filterId: filterId)
        } else {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            let filterId = "\(platforms?[indexPath.item].id ?? 0)"
            delegate?.filterGames(filterId: filterId)
            return true
        }

        return false
    }
}
