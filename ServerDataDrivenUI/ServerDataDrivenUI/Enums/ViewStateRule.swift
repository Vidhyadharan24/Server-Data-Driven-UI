//
//  ViewStateRule.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation
import AnyCodable

struct ViewStateRule: Codable {
    let hideOn: [String: AnyCodable]?
    let disableOn: [String: AnyCodable]?
    
    enum ViewStateRuleKeys: String, CodingKey {
        case hideOn = "hide_on"
        case disableOn = "disable_on"
    }
}
