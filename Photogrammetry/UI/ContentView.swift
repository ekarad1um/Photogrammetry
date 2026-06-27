//
//  ContentView.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/19/22.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var applicationViewState = ApplicationViewState.onInputView
    @StateObject var photogrammetryDelegate = PhotogrammetryDelegate()

    var body: some View {
        ZStack {
            switch applicationViewState {
            case .onInputView:
                InputView(applicationViewState: $applicationViewState, photogrammetryDelegate: photogrammetryDelegate)

            case .onConfigurationView:
                ConfigurationView(applicationViewState: $applicationViewState, photogrammetryDelegate: photogrammetryDelegate)

            case .onProcessingView:
                ProcessingView(applicationViewState: $applicationViewState, photogrammetryDelegate: photogrammetryDelegate)

            case .onExportView:
                ExportView(applicationViewState: $applicationViewState, photogrammetryDelegate: photogrammetryDelegate)
            }
        }
        .animation(.spring(), value: applicationViewState)
    }
}

// MARK: - ContentView Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
