//
//  TimerButtonViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import Combine
import AnyCodable

class TimerButtonViewModel: UIBaseActionViewModel {
    @Published var title: String
    var action: (() -> Void)?

    override var view: AnyView {
        AnyView(TimerButton(viewModel: self))
    }
    
    override var data: [String: Set<AnyCodable>] {
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
         rules: ViewStateRule? = nil,
         validations: [Validation] = [],
         title: String,
         countDownDuration: Int,
         notifyChange: ObservableObjectPublisher,
         performAction: PassthroughSubject<ViewAction, Never>) {

        self.title = title
        self.buttonTitle = title
        self.countDownDuration = countDownDuration
                
        super.init(key: key,
                   rules: rules,
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
        self.hideKeyboard()
        
        self.isLoading = true
        self.performAction.send(.apiCall(key))
    }
    
    override func actionCompleted(action: ViewAction, success: Bool) {
        super.actionCompleted(action: action, success: success)
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
