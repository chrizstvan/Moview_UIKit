//
//  Utils.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 28/11/20.
//  Copyright © 2020 ADI Consulting Test. All rights reserved.
//

import Foundation

class Utils {
    static let jsonDecoder: JSONDecoder = {
        let jsonDecode = JSONDecoder()
        jsonDecode.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecode.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecode
    }()
    
    static let dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-mm-dd"
        return formater
    }()
}
