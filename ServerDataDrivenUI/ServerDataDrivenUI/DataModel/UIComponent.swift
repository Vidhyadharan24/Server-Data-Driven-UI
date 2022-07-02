//
//  UIComponent.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 02/07/22.
//

import Foundation

enum UIComponent: String, Codable {
    case titleSubtitle = "title_subtitle"
    
    case phoneNumber = "phone_number"
    case textField = "text_field"
    
    case genericButton = "generic_button"
    case timerButton = "timer_button"
}
