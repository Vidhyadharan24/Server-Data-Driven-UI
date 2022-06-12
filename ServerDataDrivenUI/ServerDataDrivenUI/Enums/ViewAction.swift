//
//  ViewAction.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation

enum ViewAction {
    case refresh(String)
    case displayPage(String)
    case apiCall(String)
    case validatedAPICall(String)
}

enum ViewActionError: Error {
    case validationError
    case apiError
}
