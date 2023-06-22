//
//  PlantStruct.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 6/8/23.
//

import Foundation

struct Image: Codable {
    let originalURL: String
    
    enum CodingKeys: String, CodingKey {
        case originalURL = "original_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            originalURL = try container.decode(String.self, forKey: .originalURL)
        } catch{
            originalURL = ""
        }
    }
}

struct PlantStruct: Codable {
    var id: Int
    var commonName: String
    var scientificName: [String]
    var cycle: String
    var watering: String
    var defaultImage: Image?
    var sunlight: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case cycle
        case watering
        case sunlight
        case defaultImage = "default_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        commonName = try container.decode(String.self, forKey: .commonName)
        cycle = try container.decode(String.self, forKey: .cycle)
        watering = try container.decode(String.self, forKey: .watering)
        
        if let singleSciName = try? container.decode(String.self, forKey: .scientificName) {
            scientificName = [singleSciName]
        } else {
            scientificName = try container.decode([String].self, forKey: .scientificName)
        }
        if let singleSunName = try? container.decode(String.self, forKey: .sunlight) {
            sunlight = [singleSunName]
        } else {
            sunlight = try container.decode([String].self, forKey: .sunlight)
        }
        if let _ = try? container.decode(String.self, forKey: .defaultImage) {
            defaultImage = nil
            print("oof")
        } else {
            defaultImage = try container.decode(Image.self, forKey: .defaultImage)
        }
    }
}

