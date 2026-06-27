//
//  ConfigurationView.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/22/22.
//

import SwiftUI
import RealityKit

struct ConfigurationView: View {
    @Binding var applicationViewState: ApplicationViewState
    @ObservedObject var photogrammetryDelegate: PhotogrammetryDelegate

    var body: some View {
        VStack (alignment: .center, spacing: 15) {
            VStack (alignment: .leading, spacing: 5) {
                Spacer()
                Picker(LocalizedStringKey("configuration.model.detail"), selection: $photogrammetryDelegate.sessionRequestDetail) {
                    ForEach(PhotogrammetrySession.Request.Detail.allCases, id: \.self) {
                        Text($0).tag(PhotogrammetrySession.Request.Detail.init($0))
                    }
                }
                .pickerStyle(.menu)
                .padding([.leading, .trailing], 15)
                Text(LocalizedStringKey("configuration.model.detail.describe"))
                    .font(.footnote)
                    .padding([.leading, .trailing], 15)
                Spacer()
            }
            .frame(width: 320)
            .fixedSize()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            VStack (alignment: .leading, spacing: 5) {
                Spacer()
                HStack {
                    Text(LocalizedStringKey("configuration.object.masking"))
                    Spacer()
                    Toggle(LocalizedStringKey("configuration.object.masking"), isOn: $photogrammetryDelegate.sessionConfiguration.isObjectMaskingEnabled)
                        .toggleStyle(.switch)
                        .labelsHidden()
                }
                .padding([.leading, .trailing], 15)
                Text(LocalizedStringKey("configuration.object.masking.describe"))
                    .font(.footnote)
                    .padding([.leading, .trailing], 15)

                Spacer()
                Picker(LocalizedStringKey("configuration.feature.sensitivity"), selection: $photogrammetryDelegate.sessionConfiguration.featureSensitivity) {
                    ForEach(PhotogrammetrySession.Configuration.FeatureSensitivity.allCases, id: \.self) {
                        Text($0).tag(PhotogrammetrySession.Configuration.FeatureSensitivity.init($0))
                    }
                }
                .padding([.leading, .trailing], 15)
                Text(LocalizedStringKey("configuration.feature.sensitivity.describe"))
                    .font(.footnote)
                    .padding([.leading, .trailing], 15)

                Spacer()
                Picker(LocalizedStringKey("configuration.sample.ordering"), selection: $photogrammetryDelegate.sessionConfiguration.sampleOrdering) {
                    ForEach(PhotogrammetrySession.Configuration.SampleOrdering.allCases, id: \.self) {
                        Text($0).tag(PhotogrammetrySession.Configuration.SampleOrdering.init($0))
                    }
                }
                .padding([.leading, .trailing], 15)
                Text(LocalizedStringKey("configuration.sample.ordering.describe"))
                    .font(.footnote)
                    .padding([.leading, .trailing], 15)
                Spacer()
            }
            .pickerStyle(.segmented)
            .frame(width: 320)
            .fixedSize()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            HStack {
                Button(LocalizedStringKey("configuration.back")) { applicationViewState = ApplicationViewState.onInputView }
                    .keyboardShortcut(.leftArrow, modifiers: .command)

                Spacer()

                Button(LocalizedStringKey("configuration.generate.3dmodel")) { applicationViewState = ApplicationViewState.onProcessingView }
                    .keyboardShortcut("g", modifiers: .command)
            }
            .frame(width: 320)
            .fixedSize()
        }
        .padding(.all, 20)
    }
}

// MARK: - ConfigurationView Preview
struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView(
            applicationViewState: Binding.constant(ApplicationViewState.onConfigurationView),
            photogrammetryDelegate: PhotogrammetryDelegate())
    }
}
