//
//  ComponentAction.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation

enum ComponentAction {
    case refresh(String)
    case displayPage(String)
    case apiCall(String)
    case validatedAPICall(String)
}

enum ComponentActionError: Error {
    case validationError
    case apiError
}
