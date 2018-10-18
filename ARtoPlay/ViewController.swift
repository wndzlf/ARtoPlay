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
        arview.delegate = self
        
        let text = SCNText(string: "조중현입니다.", extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        text.materials = [material]
        
        let node = SCNNode()
        node.position = SCNVector3(0,0.02,-0.1)
        node.scale = SCNVector3(0.01,0.01,0.01)
        node.geometry = text
        arview.scene.rootNode.addChildNode(node)
        arview.automaticallyUpdatesLighting = true
        
        view.addSubview(arview)
        arview.showsStatistics = true
        
        
        arview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        arview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        arview.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -20).isActive = true
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

