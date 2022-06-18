//
//  GenericViewModel.swift
//  ServerDataDrivenUI
//
//  Created by Vidhyadharan Mohanram on 29/05/22.
//

import SwiftUI
import Combine
import AnyCodable

class GenericViewModel: GenericViewModelProtocol {
    let uiComponentModels: [UIComponentModel]
    
    let notifyChange = ObservableObjectPublisher()
    var performAction = PassthroughSubject<ComponentAction, Never>()

    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        let phoneFieldRules = ComponentStateRule(disableOn: ["loading": [true]])
        let phoneFieldViewModel = PhoneFieldComponentModel(key: "phone_field",
                                                      rules: phoneFieldRules,
                                                      countryCodeData: ["+91": 10,
                                                                        "+65": 8],
                                                      selectedCountryCode: "+91",
                                                      notifyChange: notifyChange,
                                                      performAction: performAction)
        
        
        let otpFieldRules = ComponentStateRule(hideOn: ["send_otp": [false]],
                                          disableOn: ["loading": [true]])
        let minLength = Validation.min(LengthValidationData(length: 4,
                                                            errorMessage: "OTP should have min 4 chars in length"))
        let maxLength = Validation.max(LengthValidationData(length: 4,
                                                            errorMessage: "OTP should be max 4 chars in length"))
        let numbers = Validation.numbers(ValidationData(errorMessage: "OTP should contain only digits"))
        
        let textFieldViewModel = TextFieldComponentModel(key: "otp_field",
                                                    rules: otpFieldRules,
                                                    validations: [minLength,
                                                                  maxLength,
                                                                  numbers],
                                                    text: "",
                                                    placeholder: "Login OTP",
                                                    notifyChange: notifyChange,
                                                    performAction: performAction)
        
        
        let sendOtpRule = ComponentStateRule(hideOn: ["send_otp": [true]],
                                        disableOn: ["loading": [true]])
        let sendOTPButton = GenericButtonComponentModel(key: "send_otp",
                                                   rules: sendOtpRule,
                                                   title: "Send OTP",
                                                   notifyChange: notifyChange,
                                                   performAction: performAction)
        
        
        let otpRules = ComponentStateRule(hideOn: ["send_otp": [false]],
                                     disableOn: ["loading": [true]])
        
        let verifyOTPButton = GenericButtonComponentModel(key: "verify_otp",
                                                     rules: otpRules,
                                                     title: "Verify OTP",
                                                     notifyChange: notifyChange,
                                                     performAction: performAction)
        
        let timerButton = TimerButtonComponentModel(key: "resend_otp_button",
                                               rules: otpRules,
                                               title: "Resend OTP",
                                               countDownDuration: 60,
                                               notifyChange: notifyChange,
                                               performAction: performAction)
        
        uiComponentModels = [phoneFieldViewModel,
                        textFieldViewModel,
                        sendOTPButton,
                        verifyOTPButton,
                        timerButton]
        
        setUpBindings()
        
        updateViewState()
    }
    
    func setUpBindings() {
        notifyChange.sink { [weak self] _ in
            self?.updateViewState()
            self?.objectWillChange.send()
        }.store(in: &cancellableSet)
        
        performAction.sink { [weak self] action in
            switch action {
            case .validatedAPICall(let key):
                guard self?.validate() == nil else {
                    self?.action(key: key,
                                 action: action,
                                 success: false)
                    return
                }
                self?.apiCall(key: key,
                              action: action)
            case .apiCall(let key):
                self?.apiCall(key: key,
                              action: action)
            default: break
            }
        }.store(in: &cancellableSet)
    }
    
    func apiCall(key: String,
                 action: ComponentAction) {
        updateViewState()
        objectWillChange.send()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.action(key: key, action: action, success: true)
        }
    }
    
    func action(key: String,
                action: ComponentAction,
                success: Bool) {
        let vm: UIComponentModel? = uiComponentModels.filter { $0.key == key }.last
        vm?.actionCompleted(action: action,
                            success: success)
        
        updateViewState()
        objectWillChange.send()
    }
    
    func updateViewState() {
        var viewData = [String: Set<AnyCodable>]()
        uiComponentModels.forEach { viewModel in
            for (key, value) in viewModel.data {
                viewData[key] = value
            }
        }
        uiComponentModels.forEach { $0.updateState(currentValues: viewData) }
    }
}
