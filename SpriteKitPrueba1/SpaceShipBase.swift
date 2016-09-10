//
//  SpaceShipBase.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 22/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit

public class SpaceShipBase {
	internal var spaceShip: SKSpriteNode = SKSpriteNode()
	internal let spaceShipScale: CGFloat = CGFloat(2)
	internal let spaceShipExplosionTime: NSTimeInterval = NSTimeInterval(1)
	internal let timeForExplotionSound: NSTimeInterval = NSTimeInterval(5)
	internal let timePerFrameAnimation: NSTimeInterval = NSTimeInterval(0.025)
	internal var gameScene: SKScene
	
	
	public init(gameScene: SKScene) {
		self.gameScene = gameScene
	}
	
	internal func playExplotionSound() {
		self.gameScene.runAction(SKAction.sequence([SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]))
	}
	
	internal func runAction(action: SKAction, completion block: () -> Void){
		self.spaceShip.runAction(action, completion: block)
	}
	
	internal func addSpaceShip() {
	}
	
	internal func addShoot() {
	}
}