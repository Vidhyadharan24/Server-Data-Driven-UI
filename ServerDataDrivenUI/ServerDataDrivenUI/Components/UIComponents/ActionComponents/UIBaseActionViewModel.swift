//
//  UIBaseActionViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation

class UIBaseActionViewModel: UIBaseViewModel, UIActionViewModel {
    var actionPerformed: Bool = false
    
    override func actionCompleted(action: ViewAction, success: Bool) {
        super.actionCompleted(action: action, success: success)
        self.actionPerformed = success
    }
}
