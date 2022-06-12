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
    @Published var isLoading: Bool = false

    var viewStateRules: ViewStateRule?
    
    var data: [String: [String: AnyCodable]] {
        return [key: [:]]
    }

    let notifyChange: ObservableObjectPublisher
    let performAction: PassthroughSubject<ViewAction, Never>
        
    var cancellableSet = Set<AnyCancellable>()

    init(key: String,
         rules: ViewStateRule?,
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ViewAction, Never>) {
        self.key = key
        self.viewStateRules = rules
        self.notifyChange = notifyChange
        self.performAction = performAction
    }
    
    func actionCompleted(action: ViewAction, success: Bool) {
        self.isLoading = false
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}
