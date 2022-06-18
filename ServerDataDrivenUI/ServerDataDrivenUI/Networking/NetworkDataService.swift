//
//  NetworkDataService.swift
//  ServerDataDrivenUI (iOS)
//
//  Created by Vidhyadharan Mohanram on 13/06/22.
//

import Foundation

public enum NetworkDataServiceError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

public protocol NetworkDataServiceProtocol {
    // BONUS TASK: Any data fetch should utilize ​Result types.
    typealias CompletionHandler = (Result<Data?, NetworkDataServiceError>) -> Void
    
    func request(endpoint: APIEndPoint, completion: @escaping CompletionHandler) -> Cancellable?
}

public class NetworkDataServiceTask: Cancellable {
    var isCancelled = false
    var networkCancellable: Cancellable? { willSet { networkCancellable?.cancel() } }
    
    public func cancel() {
        isCancelled = true
        networkCancellable?.cancel()
    }
}

public final class NetworkDataService {
    private let config: ApiConfig
    private let sessionManager: NetworkOperationsManagerProtocol
    private let logger: NetworkDataServiceErrorLoggerProtocol
    
    public init(config: ApiConfig,
                sessionManager: NetworkOperationsManagerProtocol,
                logger: NetworkDataServiceErrorLoggerProtocol = NetworkDataServiceErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
}

extension NetworkDataService: NetworkDataServiceProtocol {
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> Cancellable {
        
        let sessionDataTask = sessionManager.request(urlRequest: request) { data, response, requestError in
            self.logger.log(request: request)

            if let requestError = requestError {
                var error: NetworkDataServiceError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
    
        logger.log(request: request)

        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkDataServiceError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet, .dataNotAllowed: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension NetworkDataService {
    public func request(endpoint: APIEndPoint, completion: @escaping CompletionHandler) -> Cancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            let task = NetworkDataServiceTask()
            requestWithRetry(request: urlRequest, networkDataServiceTask: task, completion: completion)
            return task
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
    
    // BONUS TASK: Exponential backoff ​must be used​ ​when trying to reload the data.
    // Exponential back off for retrying api call failure with increasing delay.
    
    /// Fuction for performing exponential backoff when the api call fails due to network unavailability
    /// - Parameters:
    ///   - request: the url request to perform
    ///   - networkDataServiceTask: class object conforming to Cancellable protocol, holds the current network task for cancelling when api data is not required.
    ///   - retryCount: the current retry count
    ///   - completion: a completion handler for passing api data or error the caller.
    private func requestWithRetry(request: URLRequest, networkDataServiceTask: NetworkDataServiceTask, retryCount: Int = 0, completion: @escaping CompletionHandler) {
        guard !networkDataServiceTask.isCancelled else { return }
        let maxRetryCount = self.config.maxRetryCount

        let delay = getDelay(for: retryCount)
        let deadline: DispatchTime = .now() + .milliseconds(delay)
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {[weak self] in
            guard !networkDataServiceTask.isCancelled else { return }
            
            networkDataServiceTask.networkCancellable = self?.request(request: request) {[weak self] result in
                guard !networkDataServiceTask.isCancelled else { return }
                switch result {
                case .success(_):
                    completion(result)
                case .failure(let error):
                    // MARK: BUGFix - No no internet indicator' takes a very long time to appear
                    switch error {
                    case .notConnected, .cancelled: break
                    default:
                        if retryCount < maxRetryCount - 1 {
                            self?.requestWithRetry(request: request, networkDataServiceTask: networkDataServiceTask, retryCount: retryCount + 1, completion: completion)
                            return
                        }
                    }
                    return completion(.failure(error))
                }
            }
        }
    }
    
    private func getDelay(for n: Int) -> Int {
        let maxDelay = 5000 // 5 secs
        let delay = Int(pow(2.0, Double(n))) * 1000
        let jitter = Int.random(in: 0...1000)
        return min(delay + jitter, maxDelay)
    }
}

// MARK: - Logger

public protocol NetworkDataServiceErrorLoggerProtocol {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

public final class NetworkDataServiceErrorLogger: NetworkDataServiceErrorLoggerProtocol {
    public init() { }

    public func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    public func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: - NetworkDataServiceError extension

extension NetworkDataServiceError {
    public var isNotFoundError: Bool {
        if let code = isStatusCode() {
            return code == 404
        }
        return false
    }
    
    public func isStatusCode() -> Int? {
        switch self {
        case let .error(code, _):
            return code
        default: return nil
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
