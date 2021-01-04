//
//  UICollectionView+Extension.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 28/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

extension UICollectionView {
    func rigsterCellFromNib(cellIdentifer: String) {
        register(UINib(nibName: cellIdentifer, bundle: nil), forCellWithReuseIdentifier: cellIdentifer)
    }
}

extension UITableView {
    func rigsterCellFromNib(cellIdentifer: String) {
        register(UINib(nibName: cellIdentifer, bundle: nil), forCellReuseIdentifier: cellIdentifer)
    }
}

extension UICollectionReusableView {
    static var nibName: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
