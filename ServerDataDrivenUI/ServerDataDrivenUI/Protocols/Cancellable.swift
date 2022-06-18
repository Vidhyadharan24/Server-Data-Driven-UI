//
//  Cancellable.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 13/06/22.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

extension BlockOperation: Cancellable {}
