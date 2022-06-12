//
//  TitleSubtitleViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 08/06/22.
//

import SwiftUI
import Combine
import AnyCodable

class TitleSubtitleViewModel: UIBaseViewModel {
    override var view: AnyView {
        AnyView(TitleSubtitleView(viewModel: self))
    }
    
    override var data: [String: [String: AnyCodable]] {
        [key: ["text": AnyCodable(title)]]
    }
    
    @Published var title: String
    @Published var subtitles: [String]

    init(key: String,
         rules: ViewStateRule? = nil,
         title: String,
         subtitles: [String],
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ViewAction, Never>) {
        self.title = title
        self.subtitles = subtitles
        
        super.init(key: key,
                   rules: rules,
                   notifyChange: notifyChange,
                   performAction: performAction)
    }
}
