//
//  ACMNetworking+Download.swift
//
//
//  Created by burak on 22.12.2023.
//

import UIKit

public extension ACMNetworking {
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
    func download(to endpoint: ACMBaseEndpoint,
                                currentRetryCount: Int? = 0,
                                onSuccess: ACMGenericCallbacks.DownloadCallback,
                                onError: ACMGenericCallbacks.ErrorCallback)
    {
        guard let urlRequest = generateURLRequest(endpoint: endpoint) else { return }

        downloadTask = endpoint.session(delegate: self).downloadTask(with: urlRequest) { [weak self] url, urlResponse, error in
            guard let self else { return }

            self.handleNilErrorResponse(with: endpoint, error: error, onError: onError)
            self.handleConnectivityError(with: endpoint, error: error, onError: onError)

            guard let url else { return }

            guard let urlResponse else { return }

            self.cancel()

            do {
                let data = try Data(contentsOf: url)

                let model = ACMDownloadModel(data: data, localURL: url, response: urlResponse)
                onSuccess?(model)
            } catch {}


            /* guard let data = self.handleData(with: endpoint, data: data, onError: onError) else { return }
             guard let httpResponse = self.handleHttpResponse(with: endpoint, response: response, onError: onError) else { return }

             // Check if response is in valid http range
             guard self.validateResponse(with: httpResponse) else {
                 self.executeRetry(with: endpoint, httpResponse: httpResponse, data: data, currentRetryCount: currentRetryCount, onSuccess: onSuccess, onError: onError)
                 return
             }

             self.cancel()

             self.handleResult(with: endpoint, data: data, onSuccess: onSuccess, onError: onError)
              */
        }
        downloadTask?.resume()
    }
}
