//
//  ProcessingView.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/23/22.
//

import SwiftUI

struct ProcessingView: View {
    @Binding var applicationViewState: ApplicationViewState
    @ObservedObject var photogrammetryDelegate: PhotogrammetryDelegate
    @State private var photogrammetryAlert: Bool = false
    @State private var photogrammetryAlertInfo: String = String()
    @State private var animation: Bool = false

    var body: some View {
        VStack (spacing: 15) {
            Spacer()
            ZStack {
                Image(systemName: "viewfinder")
                    .font(.system(size: 100))
                    .foregroundColor(Color.secondary.opacity(0.6))
                Image(systemName: "scale.3d")
                    .font(.system(size: 60))
                    .foregroundColor(Color.secondary.opacity(0.8))

                Group {
                    Image(systemName: "gear.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(Color.secondary.opacity(0.6))
                        .shadow(radius: 3)
                        .rotationEffect(Angle(degrees: animation ? 360 : 0))
                        .onAppear {
                            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                                animation.toggle()
                            }
                        }
                }
                .padding([.leading, .top], 80)
            }
            .frame(width: 320)
            .fixedSize()
            .padding([.trailing, .leading], 15)

            ProgressView(value: photogrammetryDelegate.sessionProgress, total: 1.0)
                .frame(width: 320)
                .fixedSize()
                .padding([.trailing, .leading], 15)

            Text(photogrammetryDelegate.sessionInfo)
                .lineLimit(2)
                .frame(width: 320)
                .fixedSize(horizontal: true, vertical: true)
                .padding([.trailing, .leading], 15)

            Button(LocalizedStringKey("processing.button.cancel.processing")) { cancelProcessing() }
                .keyboardShortcut(.cancelAction)
            Spacer()
        }
        .onAppear {
            photogrammetryDelegate.generateModel { (result) in
                if case let .success(modelUrl) = result {
                    photogrammetryDelegate.outputModelUrl = modelUrl
                    applicationViewState = ApplicationViewState.onExportView
                } else if case let .failure(error) = result {
                    photogrammetryAlertInfo = error.localizedDescription
                    photogrammetryAlert = true
                }
            }
        }
        .onDisappear { photogrammetryAlertInfo.removeAll() }
        .alert(photogrammetryAlertInfo, isPresented: $photogrammetryAlert) {
            Button(LocalizedStringKey("processing.button.cancel.processing"), role: .cancel) { cancelProcessing() }
        }
    }

    private func cancelProcessing() {
        photogrammetryDelegate.cancelGeneratingModel()
        applicationViewState = .onConfigurationView
    }
}

// MARK: - ProcessingView Preview
struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(applicationViewState: Binding.constant(ApplicationViewState.onProcessingView),
                       photogrammetryDelegate: PhotogrammetryDelegate())
    }
}
