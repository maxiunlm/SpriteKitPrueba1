//
//  GameStartScene.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 29/5/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation


import SpriteKit

class GameStartScene: SKScene {
    override func didMoveToView(view: SKView) {
        steBackgroundImage()
    }
    
    private func steBackgroundImage() {
        let spaceBackground = SKSpriteNode(imageNamed:"menu")
        
        spaceBackground.zPosition = -1000
        spaceBackground.position = CGPoint (x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        spaceBackground.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
        
        backgroundColor = SKColor.blackColor()
        addChild(spaceBackground)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = GameScene(fileNamed:"GameScene") {
            let transition = SKTransition.fadeWithDuration(2)
            self.view?.presentScene(scene, transition: transition)
        }
    }
}