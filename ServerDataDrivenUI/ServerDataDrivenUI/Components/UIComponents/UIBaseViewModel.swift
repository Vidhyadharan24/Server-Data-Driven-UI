//
//  UIBaseViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 07/06/22.
//

import Foundation
import Combine
import AnyCodable
import SwiftUI

class UIBaseViewModel: UIViewModel, ObservableObject {
    var key: String
    
    var view: AnyView {
        AnyView(EmptyView())
    }
    
    @Published var isHidden: Bool = false
    @Published var isDisabled: Bool = false
    
    var viewStateRules: [ViewStateRule]
    
    func data() -> [String : AnyCodable] {
        return [:]
    }
    
    var cancellableSet = Set<AnyCancellable>()
    
    init(key: String,
         rules: [ViewStateRule] = []) {
        self.key = key
        self.viewStateRules = rules
    }
}
