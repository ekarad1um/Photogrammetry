//
//  PhotogrammetryDelegateError.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/23/22.
//

import Foundation

struct PhotogrammetryDelegateError: Error {
    enum ErrorType {
        case unsupportedHardware
        case missingInputFolderUrl
        case missingOutputModelUrl
        case failedOpenInputFolder
        case failedCreateSession
        case failedAccessSession
        case failedCompleteRequest
        case unexpectedRequestResult
    }

    var error: ErrorType
    var comment: String

    init(error: ErrorType, comment: String = String()) {
        self.error = error
        self.comment = comment
    }
}

extension PhotogrammetryDelegateError: LocalizedError {
    public var errorDescription: String? {
        switch self.error {
        case .unsupportedHardware:
            return NSLocalizedString("error.hardware.notsupport", comment: self.comment)

        case .missingInputFolderUrl:
            return NSLocalizedString("error.input.imagefolder.missing", comment: self.comment)

        case .missingOutputModelUrl:
            return NSLocalizedString("error.output.model.missing", comment: self.comment)

        case .failedOpenInputFolder:
            return NSLocalizedString("error.input.folder.open", comment: self.comment)

        case .failedCreateSession:
            return NSLocalizedString("error.create.session", comment: self.comment)

        case .failedAccessSession:
            return NSLocalizedString("error.access.session", comment: self.comment)

        case .failedCompleteRequest:
            return NSLocalizedString("error.complete.request", comment: self.comment)

        case .unexpectedRequestResult:
            return NSLocalizedString("error.unexpected.result", comment: self.comment)
        }
    }
}
