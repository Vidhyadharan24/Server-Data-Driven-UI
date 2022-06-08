//
//  Dropdown.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 31/05/22.
//

import SwiftUI

struct Dropdown: View {
    var options: [String]
    var onSelect: ((_ val: String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(self.options, id: \.self) { option in
                HStack {
                    Text(option)
                        .onTapGesture {
                            onSelect?(option)
                        }
                        .padding(.horizontal, 8)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.black, lineWidth: 0.5)
        )
    }
}

struct DropdownModifier: ViewModifier {
    @Binding var showDropdown: Bool
    @Binding var selected: String
    let options: [String]
    
    func body(content: Content) -> some View {
        if self.showDropdown {
            content
                .overlay(
                    GeometryReader { geometry in
                        VStack {
                            Spacer(minLength: geometry.size.height)
                            Dropdown(options: self.options, onSelect: { val in
                                defer {
                                    showDropdown = false
                                }
                                
                                guard val != selected else { return }
                                selected = val
                            })
                            .frame(minWidth: geometry.size.width)
                        }
                    }, alignment: .leading
                )
        } else {
            content
        }
    }
}

extension View {
    func dropdown(showDropdown: Binding<Bool>,
                  selected: Binding<String>,
                  options: [String]) -> some View {
        modifier(DropdownModifier(showDropdown: showDropdown,
                                  selected: selected,
                                  options: options))
    }
}
