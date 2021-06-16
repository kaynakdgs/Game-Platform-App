//
//  HeaderCollectionViewCell.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 28.05.2021.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerCellView: UIView!
    @IBOutlet weak var platformNameLabel: UILabel!
    let headerCellCornerRadius: CGFloat = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        headerCellView.backgroundColor = .blackTwo
        headerCellView.layer.cornerRadius = headerCellCornerRadius
        headerCellView.layer.masksToBounds = true
        platformNameLabel.textColor = .white
    }
    
    override var isSelected: Bool {
            didSet {
                if isSelected == true {
                    headerCellView.backgroundColor = .white
                    platformNameLabel.textColor = .blackTwo
                    headerCellView.layer.cornerRadius = headerCellCornerRadius
                    headerCellView.layer.masksToBounds = true
                } else {
                    headerCellView.backgroundColor = .blackTwo
                    platformNameLabel.textColor = .white
                    headerCellView.layer.cornerRadius = headerCellCornerRadius
                    headerCellView.layer.masksToBounds = true
                }
            }
        }
    
    func configure(platformTag: Result) {
        platformNameLabel.text = platformTag.name
    }
}
