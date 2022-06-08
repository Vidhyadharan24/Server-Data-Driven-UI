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
    override var view: AnyView {
        AnyView(TimerButton(viewModel: self))
    }
    
    override func data() -> [String : AnyCodable] {
        [serverKey: AnyCodable(title)]
    }
        
    @Published private var timeRemaining = 0
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    var timerCancellable: AnyCancellable?
    
    private var buttonTitle: String

    init(serverKey: String,
         rules: [ViewStateRule] = [],
         title: String) {
        self.title = title
        self.buttonTitle = title
        
        super.init(serverKey: serverKey,
                   rules: rules)
    }
        
    func pressed() {
        resetTimer()
        
        timeRemaining = 60
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timerCancellable = timer?.sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.title = "\(self.timeRemaining)"
                self.timeRemaining -= 1
                self.isDisabled = true
            } else {
                self.title = self.buttonTitle
                self.isDisabled = false
            }
        })
        
    }
    
    func resetTimer() {
        timer = nil

        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
