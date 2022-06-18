//
//  UIBaseComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 07/06/22.
//

import Foundation
import Combine
import AnyCodable
import SwiftUI

class UIBaseComponentModel: UIComponentModel, ObservableObject {
    var key: String
    
    var view: AnyView {
        AnyView(EmptyView())
    }
    
    @Published var isHidden: Bool = false
    @Published var isDisabled: Bool = false
    @Published var isLoading: Bool = false

    var viewStateRules: ComponentStateRule?
    
    var data: [String: Set<AnyCodable>] {
        return [key: []]
    }

    let notifyChange: ObservableObjectPublisher
    let performAction: PassthroughSubject<ComponentAction, Never>
        
    var cancellableSet = Set<AnyCancellable>()

    init(key: String,
         rules: ComponentStateRule?,
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ComponentAction, Never>) {
        self.key = key
        self.viewStateRules = rules
        self.notifyChange = notifyChange
        self.performAction = performAction
    }
    
    func actionCompleted(action: ComponentAction, success: Bool) {
        self.isLoading = false
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}
