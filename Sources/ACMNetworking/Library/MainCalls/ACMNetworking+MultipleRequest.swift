//
//  ACMNetworking+MultipleRequest.swift
//  
//
//  Created by burak on 2.03.2024.
//

import Foundation

public extension ACMNetworking {
    /// Multiple request function
    ///
    /// - Parameters:
    ///     - [endpoint]: base endpoint that keeps all endpoint information
    ///     - currentRetryCount(Optional): retry request count
    ///     - onSuccess: Callback for success scenario
    ///     - onError: Callback for error scenario
    ///
    /// - Returns:
    ///     - Void
    func request<T: Decodable>(to endpoints: [ACMBaseEndpoint],
                               currentRetryCount: Int? = 0,
                               onLoadingStart: ACMGenericCallbacks.VoidCallback = nil,
                               onLoadingStop: ACMGenericCallbacks.VoidCallback = nil,
                               onSuccess: ACMGenericCallbacks.ResponseCallback<T>,
                               onPartial: ACMGenericCallbacks.StreamCallback? = nil,
                               onProgress: ACMGenericCallbacks.ProgressCallback = nil,
                               onError: ACMGenericCallbacks.ErrorCallback = nil) {
        onLoadingStart?()
        let queue = OperationQueue()
        var operationList = [BlockOperation]()

        endpoints.forEach { endpoint in
            let blockOperation = BlockOperation {
                self.request(to: endpoint, onSuccess: onSuccess)
            }
            operationList.append(blockOperation)
        }

        queue.addOperations(operationList, waitUntilFinished: true)
        queue.addBarrierBlock {
            onLoadingStop?()
        }
    }
}
