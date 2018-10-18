//
//  SpaceShip.swift
//  ARtoPlay
//
//  Created by admin on 2018. 6. 29..
//  Copyright © 2018년 wndzlf. All rights reserved.
//

import ARKit

class SpaceShip: SCNNode {
    
    func loadModal() {
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/ship.scn") else {return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
    }
}
