//
//  UIBaseActionViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 12/06/22.
//

import Foundation
import Combine
import UIKit

class UIBaseActionViewModel: UIBaseViewModel {    
   
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
    
}
