//
//  InputView.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/19/22.
//

import SwiftUI

struct InputView: View {
    @Binding var applicationViewState: ApplicationViewState
    @ObservedObject var photogrammetryDelegate: PhotogrammetryDelegate
    @State private var openFolderAlert: Bool = false
    @State private var openFolderAlertInfo: String = String()

    var body: some View {
        VStack() {
            VStack (spacing: 5) {
                Text(LocalizedStringKey("input.text.drag&drop"))
                Text(LocalizedStringKey("input.text.drag&drop.hint")).font(.footnote)
            }
            .frame(width: 320, height: 280)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .onDrop(of: ["public.file-url"], delegate: OnDropDelegate(
                applicationViewState: $applicationViewState,
                photogrammetryDelegate: photogrammetryDelegate))

            Text(LocalizedStringKey("input.text.or"))
                .italic()

            Button(LocalizedStringKey("input.button.open.imagefolder")) {
                photogrammetryDelegate.openInputFolderPanel { (result) in
                    if case let .success(folderUrl) = result {
                        photogrammetryDelegate.inputFolderUrl = folderUrl
                        applicationViewState = .onConfigurationView
                    } else if case let .failure(error) = result {
                        openFolderAlertInfo = error.localizedDescription
                        openFolderAlert = true
                    }
                }
            }
            .keyboardShortcut("o", modifiers: .command)
        }
        .padding(.all, 20)
        .alert(openFolderAlertInfo, isPresented: $openFolderAlert) {
            Button(LocalizedStringKey("input.button.ok"), role: .cancel) {
                openFolderAlertInfo.removeAll()
            }
        }
    }
}

// MARK: - InputView Preview
struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(
            applicationViewState: Binding.constant(ApplicationViewState.onInputView),
            photogrammetryDelegate: PhotogrammetryDelegate())
    }
}
