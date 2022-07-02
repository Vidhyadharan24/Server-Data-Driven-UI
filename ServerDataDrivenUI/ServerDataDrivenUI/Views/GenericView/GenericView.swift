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
        var uiComponents: [AnyView] = []
        for componentModel in viewModel.uiComponentModels {
            guard !componentModel.isHidden else { continue }
            guard let uiComponent = UIComponentFactory.component(for: componentModel) else { continue }
            uiComponents.append(uiComponent)
        }
        
        return GeometryReader { geometry in
            ScrollView {
                Group {
                    VStack(spacing: 10) {
                        ForEach(0..<uiComponents.count, id:\.self) { index in
                            uiComponents[index]
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
