//
//  EnumDataModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 18/06/22.
//

import Foundation

struct EnumDataModel: Codable {
    let countries: [Country]
    
    enum CodingKeys: String, CodingKey {
        case countries = "countries"
    }
}

struct Country: Codable {
    let code: String
    let name: String
    let length: Int
}
