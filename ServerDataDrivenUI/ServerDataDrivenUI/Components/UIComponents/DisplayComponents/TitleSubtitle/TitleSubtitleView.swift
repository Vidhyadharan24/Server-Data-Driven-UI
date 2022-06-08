//
//  TitleSubtitleView.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 08/06/22.
//

import SwiftUI

struct TitleSubtitleView: View {
    @ObservedObject var viewModel: TitleSubtitleViewModel
    
    var body: some View {
        HStack {
            VStack(spacing: 8) {
                Text(viewModel.title)
                ForEach(viewModel.subtitles, id:\.self) { text in
                    Text(text)
                }
            }
            Spacer()
        }
    }
}

struct TitleSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleSubtitleView(viewModel: TitleSubtitleViewModel(serverKey: "title_subtitle_view",
                                                            title: "Title", subtitles: ["Subtitle 1",
                                                                                        "Subtitle 2"]))
    }
}
