//
//  ARContainerViewDelegate.swift
//  Photogrammetry
//
//  Created by ekarad1um on 11/24/22.
//

import Foundation
import Combine
import AppKit
import RealityKit

class ARContainerViewDelegate: ARView, ObservableObject {
    private var sceneUpdateSubscription: Cancellable?
    private var cameraEntity: PerspectiveCamera = PerspectiveCamera()
    private var cameraAnchor: AnchorEntity = AnchorEntity(world: .zero)
    private var modelEntity: Entity = Entity()
    private var modelAnchor: AnchorEntity = AnchorEntity(world: .zero)
    private var modelRadius: Float = 0 { didSet { self.updateCamera() } }
    public var modelEntitySpin: Bool = false { didSet { self.spinModelEntity() } }
    public var modelEntityRotationAngle: Float = 0 { didSet { self.updateCamera() } }

    public required init(frame: NSRect) {
        super.init(frame: frame)
        self.environment.background = .color(.clear)
        self.cameraEntity.camera.fieldOfViewInDegrees = 80
        self.cameraAnchor.addChild(self.cameraEntity)
        self.modelAnchor.addChild(self.modelEntity)
        self.scene.anchors.append(self.cameraAnchor)
        self.scene.anchors.append(self.modelAnchor)
        self.updateCamera()
    }

    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Update Camera
    @MainActor private func updateCamera() {
        let translationTransform = Transform(translation: SIMD3<Float>(0, 0, modelRadius))
        let rotationTransform = Transform(pitch: 0, yaw: modelEntityRotationAngle, roll: 0)
        let computedTransform = rotationTransform.matrix * translationTransform.matrix
        cameraAnchor.transform = Transform(matrix: computedTransform)
    }

    // MARK: - Load Model Entity
    @MainActor public func loadModelEntity(modelEntityUrl: URL, completion: @escaping (_ result: Result<Entity, Error>) -> ()) {
        do {
            scene.anchors.remove(modelAnchor)
            modelAnchor.removeChild(modelEntity)
            modelEntity = try Entity.load(contentsOf: modelEntityUrl)
            let modelEntityBounds = modelEntity.visualBounds(relativeTo: nil)
            modelEntity.transform.translation -= modelEntityBounds.center
            modelRadius = modelEntityBounds.boundingRadius * 1.8
            modelAnchor.addChild(modelEntity)
            scene.anchors.append(modelAnchor)
            completion(.success(modelEntity))
        } catch { completion(.failure(ARContainerViewDelegateError(error: .failedLoadingEntity, comment: String(describing: error)))) }
    }

    // MARK: - Spin Model Entity
    private func spinModelEntity() {
        sceneUpdateSubscription?.cancel()
        sceneUpdateSubscription = nil
        guard modelEntitySpin else { return }
        sceneUpdateSubscription = scene.subscribe(to: SceneEvents.Update.self) { [weak self] event in
            self?.modelEntityRotationAngle += Float(event.deltaTime) * 2.0
        }
    }
}
