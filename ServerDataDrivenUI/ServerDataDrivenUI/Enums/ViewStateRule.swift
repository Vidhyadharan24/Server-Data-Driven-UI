//
//  ViewStateRule.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation
import AnyCodable

struct ViewStateRule: Codable {
    let hideOn: [String: [String: AnyCodable]]?
    let disableOn: [String: [String: AnyCodable]]?
    
    init(hideOn: [String: [String: AnyCodable]]? = nil,
         disableOn: [String: [String: AnyCodable]]? = nil) {
        self.hideOn = hideOn
        self.disableOn = disableOn
    }

    enum ViewStateRuleKeys: String, CodingKey {
        case hideOn = "hide_on"
        case disableOn = "disable_on"
    }
}
