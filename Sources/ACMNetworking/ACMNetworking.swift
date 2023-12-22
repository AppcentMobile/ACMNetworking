//
//  ACMNetworking.swift
//

import Foundation

/// ACMNetworking, make requests easily
public class ACMNetworking: NSObject {
    var requestTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?

    /// Public Init function
    /// For creating object with SDK
    override public init() {
        super.init()
    }

    /// Cancels the current network request
    public func cancel() {
        cancelRequestTask()
        cancelDownloadTask()
    }

    private func cancelRequestTask() {
        if requestTask?.state == .running {
            requestTask?.cancel()
        }
        requestTask = nil
    }

    private func cancelDownloadTask() {
        if downloadTask?.state == .running {
            downloadTask?.cancel()
        }
        downloadTask = nil
    }
}
