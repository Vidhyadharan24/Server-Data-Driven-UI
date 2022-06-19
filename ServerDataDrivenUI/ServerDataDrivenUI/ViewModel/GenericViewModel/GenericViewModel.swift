//
//  GenericViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine
import AnyCodable

class GenericViewModel: GenericViewModelProtocol {
    let uiComponentModels: [UIComponentModel]
    
    let notifyChange = ObservableObjectPublisher()
    var performAction = PassthroughSubject<ComponentAction, Never>()
    
    let repo = GenericViewRepo()

    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        uiComponentModels = ComponentModelFactory.componentModels(for: repo.componentDataModels,
                                                                  notifyChange: notifyChange,
                                                                  performAction: performAction)
        
        setUpBindings()
        
        updateViewState()
    }
    
    func setUpBindings() {
        notifyChange.sink { [weak self] _ in
            self?.updateViewState()
            self?.objectWillChange.send()
        }.store(in: &cancellableSet)
        
        performAction.sink { [weak self] action in
            switch action {
            case .validatedAPICall(let key):
                guard self?.validate() == nil else {
                    self?.action(key: key,
                                 action: action,
                                 success: false)
                    return
                }
                self?.apiCall(key: key,
                              action: action)
            case .apiCall(let key):
                self?.apiCall(key: key,
                              action: action)
            default: break
            }
        }.store(in: &cancellableSet)
    }
    
    func apiCall(key: String,
                 action: ComponentAction) {
        updateViewState()
        objectWillChange.send()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.action(key: key, action: action, success: true)
        }
    }
    
    func action(key: String,
                action: ComponentAction,
                success: Bool) {
        let vm: UIComponentModel? = uiComponentModels.filter { $0.key == key }.last
        vm?.actionCompleted(action: action,
                            success: success)
        
        updateViewState()
        objectWillChange.send()
    }
    
    func updateViewState() {
        var viewData = [String: Set<AnyCodable>]()
        uiComponentModels.forEach { viewModel in
            for (key, value) in viewModel.data {
                viewData[key] = value
            }
        }
        uiComponentModels.forEach { $0.updateState(currentValues: viewData) }
    }
}
