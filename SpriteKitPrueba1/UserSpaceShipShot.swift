//
//  UserSpaceShipShot.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 23/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


open class UserSpaceShipShoot {
	fileprivate let shootScale:CGFloat = CGFloat(1.2)
	fileprivate var gameScene: SKScene
	fileprivate var userSpaceShip: SKSpriteNode
	open let shottingSpeed = 0.3
	open var isShootEnabled = true
	
	
	public init(gameScene: SKScene, userSpaceShip: SKSpriteNode) {
		self.gameScene = gameScene
		self.userSpaceShip = userSpaceShip
	}
	
	open func disposeShot(_ shoot: SKSpriteNode) {
		shoot.isHidden = true
		shoot.position.x = self.gameScene.frame.midX - self.gameScene.frame.maxX
	}
	
	
	open func addShoot() {
		if(self.isShootEnabled == false) {
			return
		}
		
		self.isShootEnabled = false
		let location = CGPoint(x: userSpaceShip.position.x, y: self.userSpaceShip.position.y + (self.userSpaceShip.size.height / 2) )
		let shoot = SKSpriteNode(imageNamed: "Shoot")
		
		shoot.xScale = self.shootScale
		shoot.yScale = self.shootScale
		shoot.position = location
		shoot.zPosition = -500
		
		shoot.physicsBody = SKPhysicsBody(rectangleOf: shoot.size)
		shoot.physicsBody?.isDynamic = true
		shoot.physicsBody?.categoryBitMask = PhysicsCategory.shot.rawValue
		shoot.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue
		shoot.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
		shoot.physicsBody?.usesPreciseCollisionDetection = true
		
		let moveAction:SKAction = SKAction.moveTo(y: self.gameScene.frame.maxY, duration: 1)
		let anotherShotAction:SKAction = SKAction.customAction(withDuration: shottingSpeed, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.shottingSpeed)) {
				self.addShoot()
			}
		})
		
		self.gameScene.addChild(shoot)
		
		shoot.run(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))
		
		if(isShootEnabled) {
			self.gameScene.run(SKAction.sequence([ SKAction.wait(forDuration: shottingSpeed), anotherShotAction]))
		}
		
		self.isShootEnabled = true
	}
}
