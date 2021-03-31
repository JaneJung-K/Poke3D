//
//  ViewController.swift
//  Poke3D
//
//  Created by mac on 2021/03/31.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main)
        {
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images Successfully Added")
            
        }
       

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    //실제 이미지가 감지되었을 때 3D 이미지를 스크린에 렌더한다.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            //감지한 이미지를 보고 참조이미지 확인하고 실제 사이즈를 가져와라
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            //투명하게 만들어서 카드를 확인할 수 있게 한다
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            //수직인 노드가 생성되었다.
            let planeNode = SCNNode(geometry: plane)
            
            //시게반대방향으로 90도 회전해서 바닥에 놓자.
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
        }
        
        
        return node
    }
}
