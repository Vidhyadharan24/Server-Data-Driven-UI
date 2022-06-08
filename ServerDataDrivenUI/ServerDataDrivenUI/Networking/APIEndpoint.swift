//
//  APIEndpoint.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation

struct APIEndPoint {
    var data: [String: Any]
    
    mutating func setAPI(data: [String: Any]) {
        self.data = data
    }
}
