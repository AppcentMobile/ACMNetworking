//
//  ACMNetworking+Request.swift
//
//
//  Created by burak on 22.12.2023.
//

import Foundation

public extension ACMNetworking {
    func stream(to endpoint: ACMBaseEndpoint,
                currentRetryCount: Int? = 0,
                onPartial: @escaping ACMGenericCallbacks.StreamCallback,
                onProgress: ACMGenericCallbacks.ProgressCallback = nil,
                onError: ACMGenericCallbacks.ErrorCallback = nil) {
        self.onPartial = onPartial

        session = endpoint.session(delegate: self)
        guard let urlRequest = generateURLRequest(endpoint: endpoint) else { return }
        requestTask = session?.dataTask(with: urlRequest)

        taskProgress = requestTask?.progress.observe(\.fractionCompleted, changeHandler: { progress, _ in
            let model = ACMProgressModel(progress: progress.fractionCompleted)
            onProgress?(model)
        })

        requestTask?.resume()
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
    func request<T: Decodable>(to endpoint: ACMBaseEndpoint,
                               currentRetryCount: Int? = 0,
                               onSuccess: ACMGenericCallbacks.ResponseCallback<T>,
                               onPartial: ACMGenericCallbacks.ResponseCallback<T> = nil,
                               onProgress: ACMGenericCallbacks.ProgressCallback = nil,
                               onError: ACMGenericCallbacks.ErrorCallback = nil) {
        guard let urlRequest = generateURLRequest(endpoint: endpoint) else { return }

        session = endpoint.session(delegate: self)

        requestTask = session?.dataTask(with: urlRequest) { [weak self] data, response, error in
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

        taskProgress = requestTask?.progress.observe(\.fractionCompleted, changeHandler: { progress, _ in
            let model = ACMProgressModel(progress: progress.fractionCompleted)
            onProgress?(model)
        })

        requestTask?.resume()
    }
}
