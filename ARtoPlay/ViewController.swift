//
//  ViewController.swift
//  ARtoPlay
//
//  Created by admin on 2018. 6. 29..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    let arview: ARSCNView = {
       let view = ARSCNView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let scene = SCNScene()
        arview.scene = scene
        
        view.addSubview(arview)
        
        arview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        arview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        arview.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -20).isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        arview.session.run(configuration)
        
        addObject()
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

