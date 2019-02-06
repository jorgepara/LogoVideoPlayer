//
//  ViewController.swift
//  LogoVideoPlayer
//
//  Created by Para Molina, Jorge on 12/9/18.
//  Copyright © 2018 Para Molina, Jorge. All rights reserved.
//

import UIKit

import ARKit


/// Main view controller, it hosts the AR scene and provides the delegate.
class ViewController: UIViewController {

    @IBOutlet weak var scene: ARSCNView!

    private let sceneUpdateQueue = DispatchQueue(label: "SerialSceneKitQueue")

    private var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        scene.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Initialize the view model
        viewModel.updateScene = { [weak self] updateSceneBlock in
            guard let strongSelf = self else { return }
            strongSelf.sceneUpdateQueue.async {
                updateSceneBlock()
            }
        }

        let configuration = viewModel.configuration

        scene.session.run(configuration, options: [])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        scene.session.pause()
    }

}

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        viewModel.anchorWasAdded(withAnchor: anchor, node: node)
    }

}
