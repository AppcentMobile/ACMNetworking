//
//  ACMNetworking.swift
//

import Foundation

/// ACMNetworking, make requests easily
public class ACMNetworking: NSObject {
    private var task: URLSessionDataTask?

    /// Public Init function
    /// For creating object with SDK
    override public init() {
        super.init()
    }

    /// Main request function
    ///
    /// - Parameters:
    ///     - endpoint: base endpoint that keeps all endpoint information
    ///     - currentRetryCount(Optional): retry request count
    ///     - onSuccess: Callback for success scenario
    ///     - onError: Callback for error scenario
    ///
    /// - Returns:
    ///     - Void
    public func request<T: Decodable>(to endpoint: ACMBaseEndpoint,
                                      currentRetryCount: Int? = 0,
                                      onSuccess: ACMGenericCallbacks.ResponseCallback<T>,
                                      onError: ACMGenericCallbacks.ErrorCallback)
    {
        guard let urlRequest = generateURLRequest(endpoint: endpoint) else { return }

        task = endpoint.session(delegate: self).dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self else { return }

            self.handleNilErrorResponse(with: endpoint, error: error, onError: onError)
            self.handleNilResponse(with: endpoint, response: response, onError: onError)
            self.handleConnectivityError(with: endpoint, error: error, onError: onError)

            guard let data = self.handleData(with: endpoint, data: data, onError: onError) else { return }
            guard let httpResponse = self.handleResponse(with: endpoint, response: response, onError: onError) else { return }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.httpStatusError,
                    "-\(httpResponse.statusCode)",
                    ACMNetworkConstants.responseInfoMessage,
                    String(data: data, encoding: .utf8) ?? "",
                ])
                ACMBaseLogger.error(message)

                // MARK: Retry mechanism

                guard let maxRetryCount = endpoint.retryCount else {
                    onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.httpStatusError, endpoint: endpoint))
                    self.cancel()
                    return
                }

                if let currentRetryCount = currentRetryCount, currentRetryCount < maxRetryCount {
                    let nextRetryCount = currentRetryCount + 1
                    ACMBaseLogger.info(ACMStringUtils.shared.merge(list: [
                        String(format: ACMNetworkConstants.httpRetryCount, nextRetryCount, maxRetryCount),
                    ]))
                    self.request(to: endpoint, currentRetryCount: nextRetryCount, onSuccess: onSuccess, onError: onError)
                } else {
                    self.cancel()
                }

                return
            }

            self.cancel()

            do {
                let info = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.responseInfoMessage,
                    String(data: data, encoding: .utf8) ?? "",
                ])
                ACMBaseLogger.info(info)

                let responseObject = try JSONDecoder().decode(T.self, from: data)
                onSuccess?(responseObject)
            } catch let DecodingError.dataCorrupted(context) {
                let message = ACMStringUtils.shared.merge(list: [
                    context.debugDescription,
                ])
                ACMBaseLogger.error(message)
            } catch let DecodingError.keyNotFound(key, context) {
                let message = ACMStringUtils.shared.merge(list: [
                    "Key \(key) not found: \(context.debugDescription)",
                    "codingPath: \(context.codingPath)",
                ])
                ACMBaseLogger.error(message)
            } catch let DecodingError.valueNotFound(value, context) {
                let message = ACMStringUtils.shared.merge(list: [
                    "Value \(value) not found: \(context.debugDescription)",
                    "codingPath: \(context.codingPath)",
                ])
                ACMBaseLogger.error(message)
            } catch let DecodingError.typeMismatch(type, context) {
                let message = ACMStringUtils.shared.merge(list: [
                    "Type \(type) mismatch: \(context.debugDescription)",
                    "codingPath: \(context.codingPath)",
                ])
                ACMBaseLogger.error(message)
            } catch let e {
                let errorMessage = String(format: ACMNetworkConstants.dataParseErrorMessage, e.localizedDescription)
                ACMBaseLogger.warning(errorMessage)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: errorMessage, endpoint: endpoint))
            }
        }
        task?.resume()
    }

    /// Stream request
    ///
    /// - Parameters:
    ///     - endpoint: base endpoint that keeps all endpoint information
    ///     - currentRetryCount(Optional): retry request count
    ///     - onSuccess: Callback for success scenario
    ///     - onError: Callback for error scenario
    ///
    /// - Returns:
    ///     - Void
    public func stream<T: Decodable>(to endpoint: ACMBaseEndpoint,
                                     currentRetryCount _: Int? = 0,
                                     onSuccess _: ACMGenericCallbacks.ResponseCallback<T>,
                                     onError: ACMGenericCallbacks.ErrorCallback)
    {
        guard let urlRequest = generateURLRequest(endpoint: endpoint) else { return }

        let task = endpoint.session(delegate: self).dataTask(with: urlRequest, completionHandler: { _, _, error in
            guard error == nil else {
                self.cancel()
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    error?.localizedDescription ?? "",
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: error?.localizedDescription, endpoint: endpoint))
                return
            }
        })
        task.resume()
    }

    /// Cancels the current network request
    public func cancel() {
        task?.cancel()
        task = nil
    }
}

private extension ACMNetworking {
    func generateURLRequest(endpoint: ACMBaseEndpoint) -> URLRequest? {
        guard var urlRequest = baseRequest(to: endpoint) else {
            ACMBaseLogger.error(ACMNetworkConstants.urlRequestErrorMessage)
            return nil
        }
        return urlRequest
    }
}

private extension ACMNetworking {
    func handleNilErrorResponse(with endpoint: ACMBaseEndpoint, error: Error?, onError: ACMGenericCallbacks.ErrorCallback) {
        guard error == nil else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                error?.localizedDescription ?? "",
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: error?.localizedDescription, endpoint: endpoint))
            return
        }
    }
}

private extension ACMNetworking {
    func handleNilResponse(with endpoint: ACMBaseEndpoint, response: URLResponse?, onError: ACMGenericCallbacks.ErrorCallback) {
        guard response != nil else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.responseNullMessage,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.responseNullMessage, endpoint: endpoint))
            return
        }
    }
}

private extension ACMNetworking {
    func handleConnectivityError(with endpoint: ACMBaseEndpoint, error: Error?, onError: ACMGenericCallbacks.ErrorCallback) {
        if error?.isConnectivityError ?? false {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.dataNullMessage,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
            return
        }
    }
}

private extension ACMNetworking {
    func handleData(with endpoint: ACMBaseEndpoint, data: Data?, onError: ACMGenericCallbacks.ErrorCallback) -> Data? {
        guard let data = data else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.dataNullMessage,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
            return nil
        }
        return data
    }
}

private extension ACMNetworking {
    func handleResponse(with endpoint: ACMBaseEndpoint, response: URLResponse?, onError: ACMGenericCallbacks.ErrorCallback) -> HTTPURLResponse? {
        guard let httpResponse = response as? HTTPURLResponse else {
            cancel()
            let message = ACMStringUtils.shared.merge(list: [
                ACMNetworkConstants.errorMessage,
                ACMNetworkConstants.httpStatusError,
            ])
            ACMBaseLogger.error(message)
            onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.httpStatusError, endpoint: endpoint))
            return nil
        }
        return httpResponse
    }
}
