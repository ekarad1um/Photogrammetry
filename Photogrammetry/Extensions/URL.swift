//
//  URL.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/22/22.
//

import Foundation
import os

private let logger = Logger(subsystem: "com.unbinilium.photogrammetry", category: "URL")

extension URL {
    var isDirectory: Bool? {
        do {
            return try resourceValues(forKeys: [.isDirectoryKey]).isDirectory
        } catch {
            logger.error("\(error.localizedDescription)")
            return nil
        }
    }
}
