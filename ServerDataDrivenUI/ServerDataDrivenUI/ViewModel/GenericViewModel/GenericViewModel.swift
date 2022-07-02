//
//  GenericViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import Foundation
import Combine
import AnyCodable

class GenericViewModel: GenericViewModelProtocol {
    let uiComponentModels: [UIComponentModel]
    
    let notifyChange = PassthroughSubject<String, Never>()
    var performAction = PassthroughSubject<UIComponentModel, Never>()
    
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
        notifyChange.sink { [weak self] componentKey in
            self?.uiComponentModels.forEach { _ = $0.resetIfNeeded(onChange: componentKey) }
            self?.updateViewState()
            self?.objectWillChange.send()
        }.store(in: &cancellableSet)
        
        performAction.sink { [weak self] actionComponentModel in            
            if let action = actionComponentModel.componentAction {
                switch action {
                case .validatedAPICall(let apiEndPoint):
                    guard self?.validate() == nil else {
                        self?.action(actionComponentModel: actionComponentModel,
                                     success: false)
                        return
                    }
                    self?.apiCall(actionComponentModel: actionComponentModel,
                                  apiEndPoint: apiEndPoint)
                case .apiCall(let apiEndPoint):
                    self?.apiCall(actionComponentModel: actionComponentModel,
                                  apiEndPoint: apiEndPoint)
                default: break
                }
            }
        }.store(in: &cancellableSet)
    }
    
    func apiCall(actionComponentModel: UIComponentModel,
                 apiEndPoint: APIEndPoint) {
        updateViewState()
        objectWillChange.send()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.action(actionComponentModel: actionComponentModel, success: true)
        }
    }
    
    func action(actionComponentModel: UIComponentModel, success: Bool) {
        actionComponentModel.actionCompleted(success: success)
        
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
