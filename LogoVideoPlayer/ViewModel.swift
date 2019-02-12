//
//  ViewModel.swift
//  LogoVideoPlayer
//
//  Created by Para Molina, Jorge on 12/9/18.
//  Copyright © 2018 Para Molina, Jorge. All rights reserved.
//

import ARKit

typealias SceneUpdateBlock = () -> Void

// Institutions whose logos can be detected
enum Institution {
    case GregorioFernandez
    case UBU
    case POLIZ

    var videoName: String {
        switch self {
        case .GregorioFernandez:
            return "gf.mp4"
        case .UBU:
            return "ubu.mp4"
        case .POLIZ:
            return "poliz.mp4"
        }
    }

    static func make(forImageName imageName: String) -> Institution? {
        switch imageName {
        case "gf":
            return .GregorioFernandez
        case "ubu":
            return .UBU
        case "poliz":
            return .POLIZ
        default:
            return nil
        }
    }
}

/// View model for the main controller. It provides the AR configuration
/// and handle the event of anchor added
class ViewModel: NSObject {

    private let detectionImagesGroup = "images"

    var updateScene: ((@escaping SceneUpdateBlock) -> Void)?

    var configuration: ARConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: detectionImagesGroup, bundle: nil) else {
            fatalError("Missing reference images")
        }
        configuration.detectionImages = referenceImages
        return configuration
    }

    /// Invoked when a new anchor is added to the scene
    ///
    /// - Parameters:
    ///   - anchor: anchor that was added
    ///   - node: node created for the new anchor
    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {

        // Check the anchor corresponds to an image, if so get the name and
        // create the institution
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        imageWasDetected(withReferenceImage: referenceImage, forNode: node)
    }

    
    /// Invoked when an image has been detected
    ///
    /// - Parameters:
    ///   - referenceImage: the referenceImage that was detected
    ///   - node: the node for the image
    private func imageWasDetected(withReferenceImage referenceImage: ARReferenceImage, forNode node: SCNNode) {

        guard let name = referenceImage.name,
            let institution = Institution.make(forImageName: name) else { return }

        updateScene? { [weak self] in
            guard let strongSelf = self else { return }
            let nodeAndPlayer = strongSelf.createVideo(forReferenceImage: referenceImage, withVideoName: institution.videoName)

            nodeAndPlayer.videoPlayer.play()

            node.addChildNode(nodeAndPlayer.videoNode)
        }
    }


    /// Creates a SKVideoNode for the image received as a parameter and the content
    /// specified by videoName
    ///
    /// - Parameters:
    ///   - referenceImage: the image that will be covered with the video
    ///   - videoName: the name of the video to play
    /// - Returns: a tuple with the node and the video player
    private func createVideo(forReferenceImage referenceImage: ARReferenceImage, withVideoName videoName: String) -> (videoNode: SCNNode, videoPlayer: SKVideoNode) {

        let width = CGFloat(referenceImage.physicalSize.width)
        let height = CGFloat(referenceImage.physicalSize.height)

        let video = SCNNode(geometry: SCNPlane(width: width, height: height))
        video.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)

        let videoPlayer = SKVideoNode(fileNamed: videoName)
        videoPlayer.yScale = -1
        let spriteKitScene = SKScene(size: CGSize(width: 600, height: 300))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayer.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoPlayer.size = spriteKitScene.size
        spriteKitScene.addChild(videoPlayer)

        video.geometry?.firstMaterial?.diffuse.contents = spriteKitScene

        return (video, videoPlayer)
    }
}
