//
//  EnemySpaceShip.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 22/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


public class EnemySpaceShip: EnemySpaceShipBase {
	private let showEnemySpeed = 3
	private let enemySpeed = 5
	private let enemyShipScale:CGFloat = CGFloat(0.8)
	//private var enemySemaphore = dispatch_semaphore_create(0)
	private let enemyShipRunActionKey: String = "enemyShip.runAction-Key"
	
	public override init(gameScene: SKScene) {
		super.init(gameScene: gameScene)

		self.explotionFileName = "explosion"
		self.maxExplotionImageIndex = 169
		self.loadExplosions()
		self.addSpaceShip()
	}
	
	internal override func addSpaceShip() {
		let xPosition: CGFloat = MathHelper.random(min: CGRectGetMinX(self.gameScene.frame) + 22, max: CGRectGetMaxX(self.gameScene.frame) - 22)
		let location = CGPoint(x: xPosition, y: CGRectGetMaxY(self.gameScene.frame) + 50)
		let enemyShip: SKSpriteNode = SKSpriteNode(imageNamed:"EnemyShip")
		let toYDestination = CGRectGetMinY(self.gameScene.frame) - CGRectGetMidY(self.gameScene.frame) / 3;
		
		enemyShip.xScale = enemyShipScale
		enemyShip.yScale = enemyShipScale
		enemyShip.position = location
		enemyShip.zPosition = 0
		
		enemyShip.physicsBody = SKPhysicsBody(circleOfRadius: enemyShip.size.width / 2)
		enemyShip.physicsBody?.dynamic = true
		enemyShip.physicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
		enemyShip.physicsBody?.contactTestBitMask = PhysicsCategory.Shot.rawValue
		enemyShip.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
		enemyShip.physicsBody?.usesPreciseCollisionDetection = false
		
		self.gameScene.addChild(enemyShip)
		
		let anotherEnemyAction:SKAction = getAddEnemyShipAction()
		let moveAction = SKAction.moveToY(toYDestination, duration: NSTimeInterval(enemySpeed))
		
		enemyShip.runAction(SKAction.sequence([SKAction.waitForDuration(1), moveAction, anotherEnemyAction, SKAction.removeFromParent()]),
		                    withKey: enemyShipRunActionKey)
	}
	
	private func getAddEnemyShipAction() -> SKAction {
		let anotherEnemyAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(showEnemySpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.showEnemySpeed)) {
				self.addSpaceShip()
			}
		})
		
		return anotherEnemyAction
	}
	
	private func doEnemyExplosion(enemy: SKSpriteNode) {
		enemy.removeActionForKey(enemyShipRunActionKey)
		enemy.hidden = false
		enemy.physicsBody = nil
		let position:CGPoint = enemy.position
		enemy.position = CGPoint(x: -CGRectGetMidX(self.gameScene.frame), y: -CGRectGetMidY(self.gameScene.frame))
		enemy.removeFromParent()
		
		let falseEnemyShip: SKSpriteNode = SKSpriteNode(imageNamed:"EnemyShip")
		falseEnemyShip.xScale = enemyShipScale
		falseEnemyShip.yScale = enemyShipScale
		falseEnemyShip.position = position
		falseEnemyShip.zPosition = 900
		self.gameScene.addChild(falseEnemyShip)
		
		falseEnemyShip.runAction(SKAction.fadeOutWithDuration(0.35), completion: {() -> Void in
			falseEnemyShip.removeFromParent()
		})
		
		let animateExplosion = SKAction.animateWithTextures(self.spaceShipExplosionImages, timePerFrame: timePerFrameAnimation)
		let enemyExplotion: SKSpriteNode = SKSpriteNode()
		enemyExplotion.texture = self.spaceShipExplosionImages[0]
		enemyExplotion.position = position
		enemyExplotion.size.height = enemy.size.height * 5
		enemyExplotion.size.width = enemy.size.height * 5
		enemyExplotion.zPosition = 800
		
		self.gameScene.addChild(enemyExplotion)
		enemyExplotion.runAction(animateExplosion, completion:  {() -> Void in
			enemyExplotion.removeFromParent()
			self.addSpaceShip()
		})
	}
	
	public func enemyDidCollideWithShip(enemy: SKSpriteNode) {
		playExplotionSound()
	}
	
	public func projectileDidCollideWithEnemy(shot: SKSpriteNode, enemy: SKSpriteNode) {
		doEnemyExplosion(enemy)
		playExplotionSound()
	}
}