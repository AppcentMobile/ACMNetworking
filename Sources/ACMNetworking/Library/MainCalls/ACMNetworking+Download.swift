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
                  currentRetryCount _: Int? = 0,
                  onSuccess: ACMGenericCallbacks.DownloadCallback,
                  onProgress: ACMGenericCallbacks.ProgressCallback = nil,
                  onError: ACMGenericCallbacks.ErrorCallback = nil)
    {
        guard let urlRequest = generateURLRequest(endpoint: endpoint) else { return }

        downloadTask = endpoint.session(delegate: self).downloadTask(with: urlRequest) { [weak self] url, urlResponse, error in
            guard let self else { return }

            self.handleNilErrorResponse(with: endpoint, error: error, onError: onError)
            self.handleNilResponse(with: endpoint, response: urlResponse, onError: onError)
            self.handleConnectivityError(with: endpoint, error: error, onError: onError)

            guard let url,
                  let urlResponse,
                  let httpResponse = self.handleHttpResponse(with: endpoint, response: urlResponse, onError: onError),
                  let pathExtension = httpResponse.url?.pathExtension
            else {
                self.cancel()
                return
            }

            self.cancel()
            self.taskProgress?.invalidate()
            self.taskProgress = nil

            do {
                let searchUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let destinationDirectory = searchUrl
                    .appendingPathComponent("ACMNetworking")

                if !FileManager.default.fileExists(atPath: destinationDirectory.relativePath) {
                    try FileManager.default.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)
                }

                let destination = destinationDirectory.appendingPathComponent(url.lastPathComponent)
                    .appendingPathExtension(pathExtension)

                try FileManager.default.moveItem(at: url, to: destination)

                let data = try Data(contentsOf: destination)

                let model = ACMDownloadModel(data: data, localURL: destination, response: urlResponse)
                onSuccess?(model)
            } catch let e {
                let errorMessage = String(format: ACMNetworkConstants.genericErrorMessage, e.localizedDescription)
                ACMBaseLogger.warning(errorMessage)
                onError?(ACMBaseNetworkError(message: ACMNetworkConstants.errorMessage, log: errorMessage, endpoint: endpoint))
            }
        }

        taskProgress = downloadTask?.progress.observe(\.fractionCompleted, changeHandler: { progress, _ in
            let model = ACMProgressModel(progress: progress.fractionCompleted)
            onProgress?(model)
        })

        downloadTask?.resume()
    }
}
