//
//  ExportView.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/23/22.
//

import SwiftUI
import RealityKit

struct ExportView: View {
    @Binding var applicationViewState: ApplicationViewState
    @ObservedObject var photogrammetryDelegate: PhotogrammetryDelegate
    @StateObject private var arContainerViewDelegate: ARContainerViewDelegate = ARContainerViewDelegate(frame: .zero)
    @State private var arContainerViewLoaded: Bool = false
    @State private var arContainerViewInfo: String = String()
    @State private var exportAlert: Bool = false
    @State private var exportAlertInfo: String = String()

    var body: some View {
        VStack (spacing: 15) {
            ZStack {
                if arContainerViewLoaded { ARContainerView(arContainerViewDelegate: arContainerViewDelegate) }
                else { Text(arContainerViewInfo) }
            }
            .frame(width: 320, height: 320)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .onAppear {
                guard let modelEntityUrl = photogrammetryDelegate.outputModelUrl else {
                    arContainerViewInfo = String(localized: "export.model.entity.missing")
                    return
                }
                arContainerViewDelegate.loadModelEntity(modelEntityUrl: modelEntityUrl) { (result) in
                    if case .success(_) = result {
                        arContainerViewLoaded = true
                        arContainerViewDelegate.modelEntitySpin = true
                    } else if case let .failure(error) = result {
                        arContainerViewInfo = error.localizedDescription
                    }
                }
            }
            .onDisappear {
                arContainerViewInfo.removeAll()
                arContainerViewLoaded = false
                arContainerViewDelegate.modelEntitySpin = false
                photogrammetryDelegate.removeOutputModel()
            }

            HStack {
                Button(LocalizedStringKey("export.button.process.again")) { applicationViewState = .onInputView }
                    .keyboardShortcut("r", modifiers: .command)

                Spacer()

                Button(LocalizedStringKey("export.button.export.usdzmodel")) {
                    photogrammetryDelegate.openExportModelPanel { result in
                        if case let .failure(error) = result {
                            exportAlertInfo = error.localizedDescription
                            exportAlert = true
                        }
                    }
                }
                .keyboardShortcut("e", modifiers: .command)
            }
            .frame(width: 320)
            .fixedSize()
        }
        .padding(.all, 20)
        .alert(exportAlertInfo, isPresented: $exportAlert) {
            Button(LocalizedStringKey("input.button.ok"), role: .cancel) { exportAlertInfo.removeAll() }
        }
    }
}

// MARK: - ExportView Preview
struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(applicationViewState: Binding.constant(ApplicationViewState.onExportView),
                   photogrammetryDelegate: PhotogrammetryDelegate())
    }
}
