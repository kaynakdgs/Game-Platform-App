//
//  GameCardTableViewCell.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 29.05.2021.
//

import UIKit

class GameCardTableViewCell: UITableViewCell {

    @IBOutlet weak var tableContentView: UIView!
    @IBOutlet weak var tableViewTitleLabel: UILabel!
    @IBOutlet weak var tableViewDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupCell() {
        tableContentView.backgroundColor = .clear
        tableViewTitleLabel.text = ""
        tableViewTitleLabel.textColor = .warmGrey
        tableViewDetailLabel.textColor = .white
    }
    
    func configure(title: String, detail: String) {
        tableViewTitleLabel.text = title
        tableViewDetailLabel.text = detail
    }
}
