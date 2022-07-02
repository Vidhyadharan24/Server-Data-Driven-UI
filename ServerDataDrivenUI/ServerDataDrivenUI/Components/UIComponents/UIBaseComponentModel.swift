//
//  UIBaseComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 07/06/22.
//

import Foundation
import Combine
import AnyCodable

class UIBaseComponentModel: UIComponentModel, ObservableObject {
    var key: String
    var uiComponent: UIComponent
    
    @Published var isHidden: Bool = false
    @Published var isDisabled: Bool = false
    @Published var isLoading: Bool = false

    var componentStateRules: ComponentStateRule?
    var componentAction: ComponentAction? = nil
    var actionPerformed: Bool = false

    var data: [String: Set<AnyCodable>] {
        return [key: []]
    }

    let notifyChange: PassthroughSubject<String, Never>
    let performAction: PassthroughSubject<UIComponentModel, Never>
        
    var cancellableSet = Set<AnyCancellable>()

    init(key: String,
         uiComponent: UIComponent,
         rules: ComponentStateRule?,
         componentAction: ComponentAction? = nil,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.key = key
        self.uiComponent = uiComponent
        self.componentStateRules = rules
        self.componentAction = componentAction
        self.notifyChange = notifyChange
        self.performAction = performAction
    }
    
    @discardableResult func resetIfNeeded(onChange: String) -> Bool {
        guard let shouldReset = componentStateRules?.resetOnChange?.contains(onChange),
              shouldReset else { return false }
        self.actionPerformed = false
        self.notifyChange.send(key)
        return true
    }
    
    func actionCompleted(success: Bool) {
        self.isLoading = false
        self.actionPerformed = success
    }
    
}
