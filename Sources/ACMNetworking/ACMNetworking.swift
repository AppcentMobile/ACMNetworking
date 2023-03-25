//
//  ACMNetworking.swift
//

import Foundation

/// ACMNetworking, make requests easily
public class ACMNetworking: NSObject {
    private var task: URLSessionDataTask?

    /// Public Init function
    /// For creating object with SDK
    public override init() {
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
        guard let urlRequest = baseRequest(to: endpoint) else {
            ACMBaseLogger.error(ACMNetworkConstants.urlRequestErrorMessage)
            return
        }

        task = endpoint.session(delegate: self).dataTask(with: urlRequest) { data, response, error in
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

            guard response != nil else {
                self.cancel()
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.responseNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.responseNullMessage, endpoint: endpoint))
                return
            }

            guard let data = data else {
                self.cancel()
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
                return
            }

            if error?.isConnectivityError ?? false {
                self.cancel()
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.dataNullMessage,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.dataNullMessage, endpoint: endpoint))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                self.cancel()
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.httpStatusError,
                ])
                ACMBaseLogger.error(message)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: ACMNetworkConstants.httpStatusError, endpoint: endpoint))
                return
            }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                let message = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.errorMessage,
                    ACMNetworkConstants.httpStatusError,
                    "-\(httpResponse.statusCode)",
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
                let responseObject = try JSONDecoder().decode(T.self, from: data)

                let info = ACMStringUtils.shared.merge(list: [
                    ACMNetworkConstants.responseInfoMessage,
                    String(data: data, encoding: .utf8) ?? "",
                ])
                ACMBaseLogger.info(info)
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

    func cancel() {
        task?.cancel()
        task = nil
    }
}
