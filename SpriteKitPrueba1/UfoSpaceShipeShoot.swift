//
//  UfoSpaceShipeShoot.swift
//  MaxiSpaceWar
//
//  Created by Maximiliano on 15/8/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


public class UfoSpaceShipShoot {
	private let shootScale:CGFloat = CGFloat(0.7)
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
	
	public func addShoot(ufoSpaceShip: SKSpriteNode) {
		let ufoSpaceShipRadius = (ufoSpaceShip.size.height / 2)
		let location = CGPoint(x: ufoSpaceShip.position.x + ufoSpaceShipRadius, y: ufoSpaceShip.position.y -  ufoSpaceShipRadius)
		let shoot = SKSpriteNode(imageNamed: "ufoShoot")
		
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
		
		let moveAction:SKAction = SKAction.moveTo(self.userSpaceShip.position, duration: 2)		
		self.gameScene.addChild(shoot)
		
		shoot.runAction(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))
	}
}
