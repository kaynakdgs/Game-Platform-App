//
//  CollectionViewCellExtension.swift
//  Final-Project
//
//  Created by Doğuş  Kaynak on 27.05.2021.
//

import Foundation

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
