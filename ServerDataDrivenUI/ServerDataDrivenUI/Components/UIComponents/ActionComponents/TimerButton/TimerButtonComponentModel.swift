//
//  TimerButtonComponentModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import Foundation
import Combine
import AnyCodable

class TimerButtonComponentModel: UIBaseComponentModel {
    @Published var title: String
    var action: (() -> Void)?
    
    override var data: [String: Set<AnyCodable>] {
        guard let componentAction = componentAction else { return [:] }
        let key: String
        switch componentAction {
        case .refresh(let apiEndPoint),
                .apiCall(let apiEndPoint),
                .validatedAPICall(let apiEndPoint):
            key = apiEndPoint.key
        case .displayScreen: return [:]
        }
        if !isLoading {
            return [key: [AnyCodable(actionPerformed)]]
        } else {
            return [key: [AnyCodable(actionPerformed)],
                    "loading": [true]]
        }
    }
    
    let countDownDuration: Int
    @Published private var timeRemaining: Int = 0
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    var timerCancellable: AnyCancellable?
    
    @Published var buttonDisabled: Bool = false
    
    private var buttonTitle: String

    init(key: String,
         uiComponent: UIComponent,
         rules: ComponentStateRule? = nil,
         validations: [Validation] = [],
         title: String,
         componentAction: ComponentAction? = nil,
         countDownDuration: Int,
         notifyChange: PassthroughSubject<String, Never>,
         performAction: PassthroughSubject<UIComponentModel, Never>) {

        self.title = title
        self.buttonTitle = title
        self.countDownDuration = countDownDuration
                
        super.init(key: key,
                   uiComponent: uiComponent,
                   rules: rules,
                   componentAction: componentAction,
                   notifyChange: notifyChange,
                   performAction: performAction)
        
        setUpBindings()
    }
    
    func setUpBindings() {
        Publishers.CombineLatest(self.$isDisabled, self.$timeRemaining)
            .sink { [weak self] (isDisabled, timeRemaining) in
                self?.buttonDisabled = isDisabled || timeRemaining > 0
            }
            .store(in: &cancellableSet)
    }
    
    func pressed() {        
        self.isLoading = true
        self.performAction.send(self)
    }
    
    override func resetIfNeeded(onChange: String) -> Bool {
        guard super.resetIfNeeded(onChange: onChange) else { return false }
        self.resetTimer()
        return true
    }
    
    override func actionCompleted(success: Bool) {
        super.actionCompleted(success: success)
        startTimer()
    }
    
    func startTimer() {
        resetTimer()
        
        timeRemaining = countDownDuration
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerCancellable = timer?
            .prepend(Date())
            .map { _ in }
            .sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining > 0 {
                self.title = "\(self.timeRemaining)"
            } else {
                self.title = self.buttonTitle
                
                self.resetTimer()
            }
        })
    }
    
    func resetTimer() {
        timer = nil

        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
