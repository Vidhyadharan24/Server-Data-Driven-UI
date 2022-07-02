//
//  GenericButtonComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import Combine
import AnyCodable

class GenericButtonComponentModel: UIBaseComponentModel {
    @Published var title: String
    
    override var data: [String: Set<AnyCodable>] {
        guard let componentAction = componentDataModel.componentAction else { return [:] }
        let key: String
        switch componentAction {
        case .refresh(let apiEndPoint),
                .apiCall(let apiEndPoint),
                .validatedAPICall(let apiEndPoint):
            key = apiEndPoint.key
        case .displayScreen: return [:]
        }
        if !isLoading {
            return [key: [AnyCodable(actionPerformed)]]
        } else {
            return [key: [AnyCodable(actionPerformed)],
                    "loading": [true]]
        }
    }
        
    init(componentDataModel: ButtonComponentDataModel,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {

        self.title = componentDataModel.title
                
        super.init(componentDataModel: componentDataModel,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
        
    func pressed() {        
        self.isLoading = true
        self.performAction.send(self)
    }
}
