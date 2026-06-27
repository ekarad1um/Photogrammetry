//
//  OnDropDelegate.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/21/22.
//

import UniformTypeIdentifiers
import SwiftUI

struct OnDropDelegate: DropDelegate {
    @Binding var applicationViewState: ApplicationViewState
    @ObservedObject var photogrammetryDelegate: PhotogrammetryDelegate

    func validateDrop(info: DropInfo) -> Bool { return info.hasItemsConforming(to: ["public.file-url"]) }

    func dropEntered(info: DropInfo) { NSSound(named: "Morse")?.play() }

    func performDrop(info: DropInfo) -> Bool {
        NSSound(named: "Submarine")?.play()
        guard let itemProvider = info.itemProviders(for: ["public.file-url"]).first,
              let identifier = itemProvider.registeredTypeIdentifiers.first else { return false }
        itemProvider.loadItem(forTypeIdentifier: identifier) { (urlData, _) in
            guard let urlData = urlData as? Data else { return }
            let itemUrl = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
            guard itemUrl.isDirectory == true else { return }
            DispatchQueue.main.async {
                photogrammetryDelegate.inputFolderUrl = itemUrl
                applicationViewState = .onConfigurationView
            }
        }
        return true
    }
}
