//
//  EnemySpaceShipShoot.swift
//  MaxiSpaceWar
//
//  Created by Maximiliano on 15/8/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


public class EnemySpaceShipShoot {
	private let shootScale:CGFloat = CGFloat(2)
	private var gameScene: SKScene
	public let shottingSpeed = 0.3
	public var isShootEnabled = true
	
	
	public init(gameScene: SKScene) {
		self.gameScene = gameScene
	}
	
	public func disposeShot(shoot: SKSpriteNode) {
		shoot.hidden = true
		shoot.position.x = CGRectGetMidX(self.gameScene.frame) - CGRectGetMaxX(self.gameScene.frame)
	}
	
	public func addShoot(enemySpaceShip: SKSpriteNode) {
		//let enemySpaceShipRadius = (enemySpaceShip.size.height / 2)
		let location = CGPoint(x: enemySpaceShip.position.x, y: enemySpaceShip.position.y)
		let shoot = SKSpriteNode(imageNamed: "enemyShoot")
		
		shoot.xScale = shootScale
		shoot.yScale = shootScale
		shoot.position = location
		shoot.zPosition = -500
		
		shoot.physicsBody = SKPhysicsBody(rectangleOfSize: shoot.size)
		shoot.physicsBody?.dynamic = true
		shoot.physicsBody?.categoryBitMask = PhysicsCategory.EnemyShot.rawValue
		shoot.physicsBody?.contactTestBitMask = PhysicsCategory.UserShip.rawValue
		shoot.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
		shoot.physicsBody?.usesPreciseCollisionDetection = true
		
		let moveAction:SKAction = SKAction.moveToY(CGRectGetMinY(self.gameScene.frame), duration: 1)
		self.gameScene.addChild(shoot)
		
		shoot.runAction(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))
	}
}

