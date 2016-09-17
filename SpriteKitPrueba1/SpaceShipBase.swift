//
//  SpaceShipBase.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 22/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit

open class SpaceShipBase {
	internal var spaceShip: SKSpriteNode = SKSpriteNode()
	internal let spaceShipScale: CGFloat = CGFloat(2.5)
	internal let spaceShipExplosionTime: TimeInterval = TimeInterval(1)
	internal let timeForExplotionSound: TimeInterval = TimeInterval(5)
	internal let timePerFrameAnimation: TimeInterval = TimeInterval(0.025)
	internal var gameScene: SKScene
	
	
	public init(gameScene: SKScene) {
		self.gameScene = gameScene
	}
	
	internal func playExplotionSound() {
		self.gameScene.run(SKAction.sequence([SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]))
	}
	
	internal func runAction(_ action: SKAction, completion block: @escaping () -> Void){
		self.spaceShip.run(action, completion: block)
	}
	
	internal func addSpaceShip() {
	}
	
	internal func addShoot() {
	}
}
