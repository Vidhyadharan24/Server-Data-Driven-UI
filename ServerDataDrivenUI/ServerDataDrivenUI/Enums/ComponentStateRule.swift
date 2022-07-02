//
//  ComponentStateRule.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation
import AnyCodable

struct ComponentStateRule: Codable {
    let hideOn: [String: Set<AnyCodable>]?
    let disableOn: [String: Set<AnyCodable>]?
    let resetOnChange: Set<String>?
    
    init(hideOn: [String: Set<AnyCodable>]? = nil,
         disableOn: [String: Set<AnyCodable>]? = nil,
         resetOnChange: Set<String>? = nil) {
        self.hideOn = hideOn
        self.disableOn = disableOn
        self.resetOnChange = resetOnChange
    }

    enum ViewStateRuleKeys: String, CodingKey {
        case hideOn = "hide_on"
        case disableOn = "disable_on"
    }
}
