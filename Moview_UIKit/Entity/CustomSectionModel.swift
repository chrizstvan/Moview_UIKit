//
//  CustomSectionModel.swift
//  Moview_UIKit
//
//  Created by Chris Stev on 04/01/21.
//  Copyright © 2021 ADI Consulting Test. All rights reserved.
//

import Foundation

struct Section<T: Hashable, U: Hashable>: Hashable {
    let headerItem: T?
    let sectionItems: U?
}

struct DataSource<T: Hashable> {
    let sections: [T]
}

// this is unnecessary type except its contain title or section properties
struct OverviewSection: Hashable {
    private let id = UUID()
    //var movie: Movie
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: OverviewSection, rhs: OverviewSection) -> Bool {
        return lhs.id == rhs.id
    }
}

// this is unnecessary type except its contain title or section properties
struct TrailerSection: Hashable {
    private let id = UUID()
    let title = "Trailer"
    //var trailers: [MovieVideo]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TrailerSection, rhs: TrailerSection) -> Bool {
        return lhs.id == rhs.id
    }
}

// this is unnecessary type exept its contain title or section properties
struct ReviewSection: Hashable {
    private let id = UUID()
    let title = "Review"
    //var reviews: [Review]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ReviewSection, rhs: ReviewSection) -> Bool {
        return lhs.id == rhs.id
    }
}
