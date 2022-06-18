//
//  ContentView.swift
//  Shared
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI

struct GenericView: View {
    @ObservedObject var viewModel = GenericViewModel()
    
    @State var presentingModal: Bool = true

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                Group {
                    VStack(spacing: 10) {
                        ForEach(0..<viewModel.uiComponentModels.count, id:\.self) { index in
                            if !viewModel.uiComponentModels[index].isHidden {
                                viewModel.uiComponentModels[index].view
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
                .padding(.horizontal, 30)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }.background(Color.init(white: 0.95))
            .edgesIgnoringSafeArea(.all)
    }
}

struct GenericView_Previews: PreviewProvider {
    static var previews: some View {
        GenericView()
    }
}
