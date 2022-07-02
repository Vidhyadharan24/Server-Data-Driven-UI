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
    let componentDataModel: ComponentDataModel

    var actionPerformed: Bool = false
    
    @Published var isHidden: Bool = false
    @Published var isDisabled: Bool = false
    @Published var isLoading: Bool = false

    var data: [String: Set<AnyCodable>] {
        return [componentDataModel.key: []]
    }

    let notifyChange: PassthroughSubject<String, Never>
    let performAction: PassthroughSubject<UIComponentModel, Never>
        
    var cancellableSet = Set<AnyCancellable>()

    init(componentDataModel: ComponentDataModel,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.componentDataModel = componentDataModel
        
        self.notifyChange = notifyChange
        self.performAction = performAction
    }
    
    @discardableResult func resetIfNeeded(onChange: String) -> Bool {
        guard let shouldReset = componentDataModel.componentStateRules?.resetOnChange?.contains(onChange),
              shouldReset else { return false }
        self.actionPerformed = false
        self.notifyChange.send(componentDataModel.key)
        return true
    }
    
    func actionCompleted(success: Bool) {
        self.isLoading = false
        self.actionPerformed = success
    }
    
}
