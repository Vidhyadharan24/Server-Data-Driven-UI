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
    
    override func data() -> [String : AnyCodable] {
        [serverKey: AnyCodable(title)]
    }
    
    @Published var title: String
    @Published var subtitles: [String]

    init(serverKey: String,
         rules: [ViewStateRule] = [],
         title: String,
         subtitles: [String]) {
        self.title = title
        self.subtitles = subtitles
        
        super.init(serverKey: serverKey,
                   rules: rules)
    }
}
