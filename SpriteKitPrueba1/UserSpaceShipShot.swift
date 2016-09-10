//
//  UserSpaceShipShot.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 23/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


public class UserSpaceShipShoot {
	private let shootScale:CGFloat = CGFloat(1.2)
	private var gameScene: SKScene
	private var userSpaceShip: SKSpriteNode
	public let shottingSpeed = 0.3
	public var isShootEnabled = true
	
	
	public init(gameScene: SKScene, userSpaceShip: SKSpriteNode) {
		self.gameScene = gameScene
		self.userSpaceShip = userSpaceShip
	}
	
	public func disposeShot(shoot: SKSpriteNode) {
		shoot.hidden = true
		shoot.position.x = CGRectGetMidX(self.gameScene.frame) - CGRectGetMaxX(self.gameScene.frame)
	}
	
	
	public func addShoot() {
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
		
		shoot.physicsBody = SKPhysicsBody(rectangleOfSize: shoot.size)
		shoot.physicsBody?.dynamic = true
		shoot.physicsBody?.categoryBitMask = PhysicsCategory.Shot.rawValue
		shoot.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy.rawValue
		shoot.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
		shoot.physicsBody?.usesPreciseCollisionDetection = true
		
		let moveAction:SKAction = SKAction.moveToY(CGRectGetMaxY(self.gameScene.frame), duration: 1)
		let anotherShotAction:SKAction = SKAction.customActionWithDuration(shottingSpeed, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.shottingSpeed)) {
				self.addShoot()
			}
		})
		
		self.gameScene.addChild(shoot)
		
		shoot.runAction(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))
		
		if(isShootEnabled) {
			self.gameScene.runAction(SKAction.sequence([ SKAction.waitForDuration(shottingSpeed), anotherShotAction]))
		}
		
		self.isShootEnabled = true
	}
}