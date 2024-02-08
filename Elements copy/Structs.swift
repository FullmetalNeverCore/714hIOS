//
//  Structs.swift
//  714h_Mikoshi
//
//  Created by 0xNeverC0RE on 06/02/2024.
//

import Foundation



struct CharData: Codable {
    let characters: [String: String]

    enum CodingKeys: String, CodingKey {
        case characters = "data"
    }
}
