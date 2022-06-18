//
//  TitleSubtitleComponent.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 08/06/22.
//

import SwiftUI
import Combine

struct TitleSubtitleComponent: View {
    @ObservedObject var componentModel: TitleSubtitleComponentModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading,
                   spacing: 8) {
                Text(componentModel.title)
                ForEach(componentModel.subtitles, id:\.self) { text in
                    Text(text)
                }
            }
            Spacer()
        }
    }
}

struct TitleSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleComponent(componentModel: TitleSubtitleComponentModel(key: "title_subtitle_view",
                                                            title: "Title",
                                                            subtitles: ["Subtitle 1",
                                                                        "Subtitle 2"],
                                                            notifyChange: ObservableObjectPublisher(),
                                                            performAction: PassthroughSubject<ComponentAction, Never>()))
    }
}
