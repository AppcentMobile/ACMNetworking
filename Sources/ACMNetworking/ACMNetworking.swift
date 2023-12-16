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
            guard let httpResponse = self.handleHttpResponse(with: endpoint, response: response, onError: onError) else { return }

            // Check if response is in valid http range
            guard self.validateResponse(with: httpResponse) else {
                self.executeRetry(with: endpoint, httpResponse: httpResponse, data: data, currentRetryCount: currentRetryCount, onSuccess: onSuccess, onError: onError)
                return
            }

            self.cancel()

            self.handleResult(with: endpoint, data: data, onSuccess: onSuccess, onError: onError)
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
