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

    var componentStateRules: ComponentStateRule?
    var componentAction: ComponentAction? = nil

    var data: [String: Set<AnyCodable>] {
        return [key: []]
    }

    let notifyChange: ObservableObjectPublisher
    let performAction: PassthroughSubject<UIActionComponentModel, Never>
        
    var cancellableSet = Set<AnyCancellable>()

    init(key: String,
         rules: ComponentStateRule?,
         componentAction: ComponentAction? = nil,
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<UIActionComponentModel, Never>) {
        self.key = key
        self.componentStateRules = rules
        self.componentAction = componentAction
        self.notifyChange = notifyChange
        self.performAction = performAction
    }
    
    func actionCompleted(success: Bool) {
        self.isLoading = false
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}
