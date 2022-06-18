//
//  ViewStateRule.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation
import AnyCodable

struct ViewStateRule: Codable {
    let hideOn: [String: Set<AnyCodable>]?
    let disableOn: [String: Set<AnyCodable>]?
    
    init(hideOn: [String: Set<AnyCodable>]? = nil,
         disableOn: [String: Set<AnyCodable>]? = nil) {
        self.hideOn = hideOn
        self.disableOn = disableOn
    }

    enum ViewStateRuleKeys: String, CodingKey {
        case hideOn = "hide_on"
        case disableOn = "disable_on"
    }
}
