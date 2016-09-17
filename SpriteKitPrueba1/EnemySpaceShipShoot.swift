//
//  EnemySpaceShipShoot.swift
//  MaxiSpaceWar
//
//  Created by Maximiliano on 15/8/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


open class EnemySpaceShipShoot {
	fileprivate let shootScale:CGFloat = CGFloat(2)
	fileprivate var gameScene: SKScene
	open let shottingSpeed = 0.3
	open var isShootEnabled = true
	
	
	public init(gameScene: SKScene) {
		self.gameScene = gameScene
	}
	
	open func disposeShot(_ shoot: SKSpriteNode) {
		shoot.isHidden = true
		shoot.position.x = self.gameScene.frame.midX - self.gameScene.frame.maxX
	}
	
	open func addShoot(_ enemySpaceShip: SKSpriteNode) {
		//let enemySpaceShipRadius = (enemySpaceShip.size.height / 2)
		let location = CGPoint(x: enemySpaceShip.position.x, y: enemySpaceShip.position.y)
		let shoot = SKSpriteNode(imageNamed: "enemyShoot")
		
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
		
		let moveAction:SKAction = SKAction.moveTo(y: self.gameScene.frame.minY, duration: 1)
		self.gameScene.addChild(shoot)
		
		shoot.run(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))
	}
}

