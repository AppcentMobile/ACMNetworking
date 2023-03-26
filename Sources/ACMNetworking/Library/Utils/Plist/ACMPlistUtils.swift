//
//  ACMPlistUtils.swift
//

import Foundation

/// ACMPlistUtils
///
/// Utility class for plist
final class ACMPlistUtils {
    static let shared = ACMPlistUtils()

    var config: ACMPlistModel? {
        guard let path = Bundle.main.path(forResource: ACMPListContants.fileName, ofType: ACMPListContants.fileExtension) else {
            throwFatalError(with: ACMPropertyListSerializationError.fileNotFound)
            return nil
        }
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)

            guard let plist = getList(with: data) else {
                throwFatalError(with: ACMPropertyListSerializationError.fileNotParsed)
                return nil
            }

            return plist
        } catch {
            throwFatalError(with: ACMPropertyListSerializationError.dataNotAvailable)
            return nil
        }
    }

    private func getList(with data: Data) -> ACMPlistModel? {
        let decoder = PropertyListDecoder()
        do {
            let model = try decoder.decode(ACMPlistModel.self, from: data)
            return model
        } catch let DecodingError.dataCorrupted(context) {
            throwFatalError(with: ACMPropertyListSerializationError.dataCorrupted(context: context))
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            throwFatalError(with: ACMPropertyListSerializationError.keyNotFound(key: key, context: context))
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            throwFatalError(with: ACMPropertyListSerializationError.valueNotFound(value: value, context: context))
            return nil
        } catch let DecodingError.typeMismatch(type, context) {
            throwFatalError(with: ACMPropertyListSerializationError.typeMismatch(type: type, context: context))
            return nil
        } catch {
            throwFatalError(with: ACMPropertyListSerializationError.modelNotParsed)
            return nil
        }
    }

    private func throwFatalError(with error: ACMPropertyListSerializationError) {
        if ACMNetworkingConstants.configOverride == false {
            fatalError(error.localizedDescription)
        }
    }
}
