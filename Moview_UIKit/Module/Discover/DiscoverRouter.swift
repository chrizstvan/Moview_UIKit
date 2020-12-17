//
//  DiscoverRouter.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

protocol DiscoverRouterProtocol {
    func routeToGenreList(view: DiscoverViewProtocol, genre: Genre)
}

final class DiscoverRouter: DiscoverRouterProtocol {
    func routeToGenreList(view: DiscoverViewProtocol, genre: Genre) {
        if let superVC = view as? UIViewController {
            let vc = GenreListBuilder(genre: genre).build()
            superVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
