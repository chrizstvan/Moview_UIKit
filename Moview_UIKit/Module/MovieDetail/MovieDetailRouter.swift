//
//  MovieDetailRouter.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 17/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

protocol MovieDetailRouterProtocol {
    func showYoutubeTrailer(view: MovieDetailViewProtocol, pageTitle: String, url: URL)
}

final class MovieDetailRouter: MovieDetailRouterProtocol  {
    func showYoutubeTrailer(view: MovieDetailViewProtocol, pageTitle: String, url: URL) {
        if let superVC = view as? UIViewController {
            let destination = WebViewController(url: url, title: pageTitle)
            let navVC = UINavigationController(rootViewController: destination)
            superVC.present(navVC, animated: true)
        }
    }    
}
