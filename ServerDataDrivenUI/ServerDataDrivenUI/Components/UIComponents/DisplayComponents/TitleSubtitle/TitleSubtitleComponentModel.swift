//
//  TitleSubtitleComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 08/06/22.
//

import Combine
import AnyCodable

class TitleSubtitleComponentModel: UIBaseComponentModel {
    
    override var data: [String: Set<AnyCodable>] {
        [key: [AnyCodable(title)]]
    }
    
    @Published var title: String
    @Published var subtitles: [String]

    init(key: String,
         uiComponent: UIComponent,
         rules: ComponentStateRule? = nil,
         componentAction: ComponentAction? = nil,
         title: String,
         subtitles: [String],
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.title = title
        self.subtitles = subtitles
        
        super.init(key: key,
                   uiComponent: uiComponent,
                   rules: rules,
                   componentAction: componentAction,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}
