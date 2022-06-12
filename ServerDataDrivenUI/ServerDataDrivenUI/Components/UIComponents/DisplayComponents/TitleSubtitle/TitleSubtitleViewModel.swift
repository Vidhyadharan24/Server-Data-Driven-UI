//
//  TitleSubtitleViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 08/06/22.
//

import SwiftUI
import AnyCodable

class TitleSubtitleViewModel: UIBaseViewModel {
    override var view: AnyView {
        AnyView(TitleSubtitleView(viewModel: self))
    }
    
    override var data: [String: AnyCodable] {
        [key: AnyCodable(title)]
    }
    
    @Published var title: String
    @Published var subtitles: [String]

    init(key: String,
         rules: ViewStateRule? = nil,
         title: String,
         subtitles: [String]) {
        self.title = title
        self.subtitles = subtitles
        
        super.init(key: key,
                   rules: rules)
    }
}
