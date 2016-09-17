//
//  UfoSpaceShipeShoot.swift
//  MaxiSpaceWar
//
//  Created by Maximiliano on 15/8/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


open class UfoSpaceShipShoot {
	fileprivate let shootScale:CGFloat = CGFloat(2)
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
	
	open func addShoot(_ ufoSpaceShip: SKSpriteNode) {
		let ufoSpaceShipRadius = (ufoSpaceShip.size.height / 2)
		let location = CGPoint(x: ufoSpaceShip.position.x + ufoSpaceShipRadius, y: ufoSpaceShip.position.y -  ufoSpaceShipRadius)
		let shoot = SKSpriteNode(imageNamed: "ufoShoot")
		
		shoot.xScale = shootScale
		shoot.yScale = shootScale
		shoot.position = location
		shoot.zPosition = -500
		
		shoot.physicsBody = SKPhysicsBody(rectangleOf: shoot.size)
		shoot.physicsBody?.isDynamic = true
		shoot.physicsBody?.categoryBitMask = PhysicsCategory.enemyShot.rawValue
		shoot.physicsBody?.contactTestBitMask = PhysicsCategory.userShip.rawValue
		shoot.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
		shoot.physicsBody?.usesPreciseCollisionDetection = true
		
		let moveAction:SKAction = SKAction.move(to: self.userSpaceShip.position, duration: 2)		
		self.gameScene.addChild(shoot)
		
		shoot.run(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))
	}
}
