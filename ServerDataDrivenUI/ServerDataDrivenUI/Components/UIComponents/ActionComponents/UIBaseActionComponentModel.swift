//
//  UIBaseActionComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation

class UIBaseActionComponentModel: UIBaseComponentModel, UIActionComponentModel {
    var actionPerformed: Bool = false

    override func actionCompleted(success: Bool) {
        super.actionCompleted(success: success)
        self.actionPerformed = success
    }
}
