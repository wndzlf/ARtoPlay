//
//  ViewController.swift
//  ARtoPlay
//
//  Created by admin on 2018. 6. 29..
//  Copyright © 2018년 wndzlf. All rights reserved.
//
import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    let arview: ARSCNView = {
       let view = ARSCNView()
        let scene = SCNScene()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.scene = scene
       return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //arview.delegate = self
        
//        let text = SCNText(string: "==========================================", extrusionDepth: 1)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.yellow
//        text.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(0,0.02,-0.1)
//        node.scale = SCNVector3(0.01,0.01,0.01)
//        node.geometry = text
//        arview.scene.rootNode.addChildNode(node)
//        arview.automaticallyUpdatesLighting = true
        
        addBox()
        addTapGestureToArView()
        
        view.addSubview(arview)
        //arview.showsStatistics = true
        arview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        arview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        arview.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -20).isActive = true
    }
    
    //Removing Object From ARSCNView
    func addBox(x: Float = 0 , y: Float = 0 , z: Float = -0.2) {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x,y,z)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        arview.scene = scene
    }
    
    //Adding Gesture Recognizer to ARSCNView
    func addTapGestureToArView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(withGestureRecognizer:)))
        arview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: arview)
        let hitTestResults = arview.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = arview.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        arview.session.run(configuration)
        //addObject()
    }
    override func viewWillDisappear(_ animated: Bool) {
        arview.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
    }
    
    func addObject() {
        let ship = SpaceShip()
        ship.loadModal()
        
        let xPos = randomPostion(lowerBound: -1.5, upperBound: 1.5)
        let yPos = randomPostion(lowerBound: -1.5, upperBound: 1.5)
        
        ship.position = SCNVector3(xPos, yPos, -1)
        arview.scene.rootNode.addChildNode(ship)
    }
    
    func randomPostion(lowerBound lower:Float, upperBound upper:Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: arview)
            
            let hitList = arview.hitTest(location, options: nil)
            
            if let hitObject = hitList.first {
                let node = hitObject.node
                
                if node.name == "ARShip"{
                    node.removeFromParentNode()
                    addObject()
                }
            }
        }
    }
}

//transfroms a matrix into float3. it gives us x, y, z
extension float4x4{
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
