//
//  NetworkOperationsManager.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 13/06/22.
//

import Foundation

public protocol NetworkOperationsManagerProtocol {
    typealias CompletionHandler = ((Data?, URLResponse?, Error?) -> Void)

    func request(urlRequest: URLRequest, completion: @escaping CompletionHandler) -> Cancellable
}

public class NetworkOperationsManager: NetworkOperationsManagerProtocol {
    
    lazy var networkQueue: OperationQueue = {
        let networkQueue = OperationQueue()
        networkQueue.maxConcurrentOperationCount = 1
        return networkQueue
    }()
    
    public init() {}
    public func request(urlRequest: URLRequest, completion: @escaping CompletionHandler) -> Cancellable {
        let blockOperation = BlockOperation.init {
            let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        }
        networkQueue.addOperation(blockOperation)
        
        return blockOperation
    }
    
}
