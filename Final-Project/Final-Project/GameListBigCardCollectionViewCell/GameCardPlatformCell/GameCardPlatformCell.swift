//
//  GameCardPlatformCell.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 30.05.2021.
//

import UIKit

class GameCardPlatformCell: UICollectionViewCell {

    @IBOutlet weak var platformTagViewContainer: UIView!
    @IBOutlet weak var platformTagLabel: UILabel!
    let platformCellCornerRadius: CGFloat = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        platformTagViewContainer.backgroundColor = .blackTwo
        platformTagViewContainer.layer.cornerRadius = platformCellCornerRadius
        platformTagViewContainer.layer.masksToBounds = true
        platformTagLabel.textColor = .white
    }
    
    func configure(platformTag: EsrbRating) {
        platformTagLabel.text = platformTag.name
    }
}
