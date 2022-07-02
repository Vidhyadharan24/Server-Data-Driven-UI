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
        [componentDataModel.key: [AnyCodable(title)]]
    }
    
    @Published var title: String
    @Published var subtitles: [String]

    init(componentDataModel: ComponentDataModel,
         title: String,
         subtitles: [String],
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {
        self.title = title
        self.subtitles = subtitles
        
        super.init(componentDataModel: componentDataModel,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}
