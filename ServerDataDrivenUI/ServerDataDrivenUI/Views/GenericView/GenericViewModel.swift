//
//  GenericViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine

protocol GenericViewModelProtocol: ObservableObject, Validator {    
    var uiViewModels: [UIViewModel] { get }
}

class GenericViewModel: GenericViewModelProtocol {
    let uiViewModels: [UIViewModel]
    
    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        let phoneFieldViewModel = PhoneFieldViewModel(serverKey: "phone_field",
                                                      countryCodes: ["+91",
                                                                     "+65"],
                                                      selectedCountryCode: "+91")
        let textFieldViewModel = TextFieldViewModel(serverKey: "otp_field",
                                                    text: "")
        
        let genericButton = GenericButtonViewModel(serverKey: "login_button",
                                                   title: "Login")
        let timerButton = TimerButtonViewModel(serverKey: "resend_otp_button",
                                               title: "Resend OTP")
        
        uiViewModels = [phoneFieldViewModel,
                        textFieldViewModel,
                        genericButton,
                        timerButton]
        
        for uiViewModel in uiViewModels {
            guard let inputViewModel = uiViewModel as? UIInputViewModel else { continue }
            inputViewModel.notifyChange { [weak self] in
                self?.objectWillChange.send()
            }
        }
    }
}
