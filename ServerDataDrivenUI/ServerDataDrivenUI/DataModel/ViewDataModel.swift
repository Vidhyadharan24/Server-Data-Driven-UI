//
//  ViewDataModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 18/06/22.
//

import Foundation

struct ViewDataModel: Codable {
    let views: [String: [UIComponentDataModel]]
}

enum UIComponentDataModel: Codable {
    case phoneNumber(PhoneComponentDataModel)
    case textField(TextFieldComponentDataModel)
    case button(ButtonComponentDataModel)
    case timerButton(TimerButtonComponentDataModel)
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case textField = "text_field"
        case button = "button"
        case timerButton = "timer_button"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(PhoneComponentDataModel.self, forKey: .phoneNumber) {
            self = .phoneNumber(value)
        } else if let value = try? container.decode(TextFieldComponentDataModel.self, forKey: .textField) {
            self = .textField(value)
        } else if let value = try? container.decode(ButtonComponentDataModel.self, forKey: .button) {
            self = .button(value)
        } else if let value = try? container.decode(TimerButtonComponentDataModel.self, forKey: .timerButton) {
            self = .timerButton(value)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Data doesn't match"))
        }
    }
}

protocol ComponentDataModel: Codable {}

struct PhoneComponentDataModel: ComponentDataModel {
    let key: String
    let uiComponent: UIComponent
    let countryCodeKey: String
    let phoneNumberKey: String
    let componentStateRules: ComponentStateRule?
    let componentAction: ComponentAction?

    enum CodingKeys: String, CodingKey {
        case key
        case uiComponent = "ui_component"
        case countryCodeKey = "country_code_key"
        case phoneNumberKey = "phone_number_key"
        case componentStateRules = "component_state_rules"
        case componentAction = "component_action"
    }
}

struct TextFieldComponentDataModel: ComponentDataModel {
    let key: String
    let uiComponent: UIComponent
    let defaultText: String?
    let placeholder: String?
    let validations: [Validation]?
    let componentStateRules: ComponentStateRule?
    let componentAction: ComponentAction?

    enum CodingKeys: String, CodingKey {
        case key
        case uiComponent = "ui_component"
        case defaultText = "default_text"
        case placeholder
        case validations
        case componentStateRules = "component_state_rules"
        case componentAction = "component_action"
    }
}

struct ButtonComponentDataModel: ComponentDataModel {
    let key: String
    let uiComponent: UIComponent
    let title: String
    let componentStateRules: ComponentStateRule?
    let componentAction: ComponentAction?
    
    enum CodingKeys: String, CodingKey {
        case key
        case uiComponent = "ui_component"
        case title
        case componentStateRules = "component_state_rules"
        case componentAction = "component_action"
    }
}

struct TimerButtonComponentDataModel: ComponentDataModel {
    let key: String
    let uiComponent: UIComponent
    let title: String
    let countDownDuration: Int
    let componentStateRules: ComponentStateRule?
    let componentAction: ComponentAction?

    enum CodingKeys: String, CodingKey {
        case key
        case uiComponent = "ui_component"
        case title
        case countDownDuration = "count_down_duration"
        case componentStateRules = "component_state_rules"
        case componentAction = "component_action"
    }
}
