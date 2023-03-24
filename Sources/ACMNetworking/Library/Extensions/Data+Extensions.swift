//
//  Data+Extensions.swift
//

import Foundation

public struct ACMFileModel {
    var ext: String
    var mime: String
}

extension Data {
    private static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",
        0x89: "image/png",
        0x47: "image/gif",
        0x49: "image/tiff",
        0x4D: "image/tiff",
        0x25: "application/pdf",
        0xD0: "application/vnd",
        0x46: "text/plain",
    ]

    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }

    var fileModel: ACMFileModel {
        return ACMFileModel(ext: mimeType.components(separatedBy: "/").last ?? "", mime: mimeType)
    }
}