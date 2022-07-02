//
//  UIActionComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation
import Combine

protocol UIActionComponentModel: UIComponentModel {
    var actionPerformed: Bool { get set }
    var componentAction: ComponentAction? { get }
}
