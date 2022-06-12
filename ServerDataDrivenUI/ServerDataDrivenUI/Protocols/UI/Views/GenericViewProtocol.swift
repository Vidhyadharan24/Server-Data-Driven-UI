//
//  GenericViewProtocol.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation
import Combine

protocol GenericViewModelProtocol: ObservableObject, Validator {
    var uiViewModels: [UIViewModel] { get }
}
