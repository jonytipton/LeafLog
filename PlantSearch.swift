//
//  PlantSearch.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 6/8/23.
//

import Foundation

struct PlantSearch: Codable {
    let data: [PlantID]
}

struct PlantID: Codable {
    let id: Int
}
