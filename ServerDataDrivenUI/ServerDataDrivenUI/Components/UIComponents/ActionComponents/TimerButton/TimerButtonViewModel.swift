//
//  TimerButtonViewModel.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 04/06/22.
//

import SwiftUI
import Combine
import AnyCodable

class TimerButtonViewModel: UIBaseViewModel {
    @Published var title: String
    var action: (() -> Void)?

    override var view: AnyView {
        AnyView(TimerButton(viewModel: self))
    }
    
    override var data: [String: AnyCodable] {
        if !isLoading {
            return [key: AnyCodable(actionPerformed)]
        } else {
            return [key: AnyCodable(actionPerformed),
                    "loading": true]
        }
    }
    
    @Published var isLoading: Bool = false
    var actionPerformed: Bool = false

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
         action: (() -> Void)? = nil) {

        self.title = title
        self.buttonTitle = title
        self.countDownDuration = countDownDuration
        
        self.action = action
        
        super.init(key: key,
                   rules: rules)
        
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
        self.objectDidChange.send()
        action?()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.actionPerformed = true
            self.objectDidChange.send()
            self.showTimer()
        }
    }
    
    func showTimer() {
        resetTimer()
        
        timeRemaining = countDownDuration
        
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerCancellable = timer?
            .prepend(Date())
            .map { _ in }
            .sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.title = "\(self.timeRemaining)"
                self.timeRemaining -= 1
            } else {
                self.title = self.buttonTitle
            }
        })
    }
    
    func resetTimer() {
        timer = nil

        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
