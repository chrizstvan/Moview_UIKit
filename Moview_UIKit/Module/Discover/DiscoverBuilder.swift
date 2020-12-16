//
//  DiscoverBuilder.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 16/12/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import UIKit

final class DiscoverBuilder {
    func build() -> UIViewController {
        let view = NibDiscoverViewController()
        let presenter = DiscoverPresenter()
        let interactor = DiscoverInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        interactor.presnter = presenter
        presenter.view = view
        
        return view
    }
}
