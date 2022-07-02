//
//  TitleSubtitleComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 08/06/22.
//

import SwiftUI
import Combine
import AnyCodable

class TitleSubtitleComponentModel: UIBaseComponentModel {
    override var view: AnyView {
        AnyView(TitleSubtitleComponent(componentModel: self))
    }
    
    override var data: [String: Set<AnyCodable>] {
        [key: [AnyCodable(title)]]
    }
    
    @Published var title: String
    @Published var subtitles: [String]

    init(key: String,
         rules: ComponentStateRule? = nil,
         title: String,
         subtitles: [String],
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ComponentAction, Never>) {
        self.title = title
        self.subtitles = subtitles
        
        super.init(key: key,
                   rules: rules,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}