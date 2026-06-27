//
//  PhotogrammetrySession.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/22/22.
//

import RealityKit

extension PhotogrammetrySession.Request.Detail {
    public static let allCases = ["Preview", "Reduced", "Medium", "Full", "Raw"]

    init(_ detail: String = String()) {
        switch detail {
        case "Preview": self = .preview
        case "Reduced": self = .reduced
        case "Medium": self = .medium
        case "Full": self = .full
        case "Raw": self = .raw
        default: self = .preview
        }
    }
}

extension PhotogrammetrySession.Configuration.FeatureSensitivity {
    public static let allCases = ["Normal", "High"]

    init(_ featureSensitivity: String = String()) {
        switch featureSensitivity {
        case "Normal": self = .normal
        case "High": self = .high
        default: self = .normal
        }
    }
}

extension PhotogrammetrySession.Configuration.SampleOrdering {
    public static let allCases = ["Unordered", "Sequential"]

    init(_ sampleOrdering: String = String()) {
        switch sampleOrdering {
        case "Unordered": self = .unordered
        case "Sequential": self = .sequential
        default: self = .unordered
        }
    }
}
