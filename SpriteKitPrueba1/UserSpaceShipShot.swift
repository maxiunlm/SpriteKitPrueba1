//
//  UserSpaceShipShot.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 23/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


public class UserSpaceShipShot {
	private let shotScale:CGFloat = CGFloat(0.5)
	private var gameScene: SKScene
	private var userSpaceShip: SKSpriteNode
	public let shottingSpeed = 0.3
	public var isShotEnabled = true
	
	
	public init(gameScene: SKScene, userSpaceShip: SKSpriteNode) {
		self.gameScene = gameScene
		self.userSpaceShip = userSpaceShip
	}
	
	public func disposeShot(shot: SKSpriteNode) {
		shot.hidden = true
		shot.position.x = CGRectGetMidX(self.gameScene.frame) - CGRectGetMaxX(self.gameScene.frame)
	}
	
	
	public func addShot() {
		let location = CGPoint(x: userSpaceShip.position.x, y: self.userSpaceShip.position.y + (self.userSpaceShip.size.height / 2) )
		let shot = SKSpriteNode(imageNamed: "Shot")
		
		shot.xScale = shotScale
		shot.yScale = shotScale
		shot.position = location
		shot.zPosition = -500
		
		shot.physicsBody = SKPhysicsBody(rectangleOfSize: shot.size)
		shot.physicsBody?.dynamic = true
		shot.physicsBody?.categoryBitMask = PhysicsCategory.Shot.rawValue
		shot.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy.rawValue
		shot.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
		shot.physicsBody?.usesPreciseCollisionDetection = true
		
		let moveAction:SKAction = SKAction.moveToY(CGRectGetMaxY(self.gameScene.frame), duration: 1)
		let anotherShotAction:SKAction = SKAction.customActionWithDuration(shottingSpeed, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.shottingSpeed)) {
				self.addShot()
			}
		})
		
		self.gameScene.addChild(shot)
		
		shot.runAction(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))
		
		if(isShotEnabled) {
			self.gameScene.runAction(SKAction.sequence([ SKAction.waitForDuration(shottingSpeed), anotherShotAction]))
		}
	}
}