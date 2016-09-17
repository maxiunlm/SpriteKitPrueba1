//
//  EnemySpaceShip.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 22/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


open class EnemySpaceShip: EnemySpaceShipBase {
	fileprivate var enemySpaceShipShoot: EnemySpaceShipShoot?
	fileprivate let showEnemySpeed = 3
	fileprivate let enemySpeed = 5
	fileprivate let enemyShipRunActionKey: String = "enemyShip.runAction-Key"
	
	public override init(gameScene: SKScene) {
		super.init(gameScene: gameScene)
		
		self.enemySpaceShipShoot = EnemySpaceShipShoot(gameScene: self.gameScene)
		self.explotionFileName = "explosion"
		self.maxExplotionImageIndex = 169
		self.loadExplosions()
		self.addSpaceShip()
	}
	
	internal override func addSpaceShip() {
		self.enemySpaceShipShoot!.isShootEnabled = true;
		let xPosition: CGFloat = MathHelper.random(min: self.gameScene.frame.minX + 22, max: self.gameScene.frame.maxX - 22)
		let location = CGPoint(x: xPosition, y: self.gameScene.frame.maxY + 50)
		self.spaceShip = SKSpriteNode(imageNamed:"EnemyShip")
		let toYDestination = self.gameScene.frame.minY - self.gameScene.frame.midY / 3;
		
		self.spaceShip.xScale = self.spaceShipScale
		self.spaceShip.yScale = self.spaceShipScale
		self.spaceShip.position = location
		self.spaceShip.zPosition = 0
		
		self.spaceShip.physicsBody = SKPhysicsBody(circleOfRadius: self.spaceShip.size.width / 2)
		self.spaceShip.physicsBody?.isDynamic = true
		self.spaceShip.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
		self.spaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.shot.rawValue
		self.spaceShip.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
		self.spaceShip.physicsBody?.usesPreciseCollisionDetection = false
		
		self.gameScene.addChild(self.spaceShip)
		
		let anotherEnemyAction:SKAction = getAddEnemyShipAction()
		let moveAction = SKAction.moveTo(y: toYDestination, duration: TimeInterval(enemySpeed))
		let shootAktion = self.getShootAktion()
		
		self.spaceShip.run(SKAction.sequence([SKAction.wait(forDuration: 1), moveAction, anotherEnemyAction, SKAction.removeFromParent()]),
		                         withKey: enemyShipRunActionKey)
		
		self.gameScene.run(shootAktion)
	}
	
	fileprivate func getAddEnemyShipAction() -> SKAction {
		let anotherEnemyAction:SKAction = SKAction.customAction(withDuration: TimeInterval(showEnemySpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.showEnemySpeed)) {
				self.addSpaceShip()
			}
		})
		
		return anotherEnemyAction
	}
	
	fileprivate func doEnemyExplosion(_ enemy: SKSpriteNode) {
		enemy.removeAction(forKey: enemyShipRunActionKey)
		enemy.isHidden = false
		enemy.physicsBody = nil
		let position:CGPoint = enemy.position
		enemy.position = CGPoint(x: -self.gameScene.frame.midX, y: -self.gameScene.frame.midY)
		enemy.removeFromParent()
		
		let falseEnemyShip: SKSpriteNode = SKSpriteNode(imageNamed:"EnemyShip")
		falseEnemyShip.xScale = self.spaceShipScale
		falseEnemyShip.yScale = self.spaceShipScale
		falseEnemyShip.position = position
		falseEnemyShip.zPosition = 900
		self.gameScene.addChild(falseEnemyShip)
		
		falseEnemyShip.run(SKAction.fadeOut(withDuration: 0.35), completion: {() -> Void in
			falseEnemyShip.removeFromParent()
		})
		
		let animateExplosion = SKAction.animate(with: self.spaceShipExplosionImages, timePerFrame: timePerFrameAnimation)
		let enemyExplotion: SKSpriteNode = SKSpriteNode()
		enemyExplotion.texture = self.spaceShipExplosionImages[0]
		enemyExplotion.position = position
		enemyExplotion.size.height = enemy.size.height * 5
		enemyExplotion.size.width = enemy.size.height * 5
		enemyExplotion.zPosition = 800
		
		self.gameScene.addChild(enemyExplotion)
		enemyExplotion.run(animateExplosion, completion:  {() -> Void in
			enemyExplotion.removeFromParent()
			self.addSpaceShip()
		})
	}
	
	open func enemyDidCollideWithShip(_ enemy: SKSpriteNode) {
		playExplotionSound()
	}
	
	open func projectileDidCollideWithEnemy(_ shot: SKSpriteNode, enemy: SKSpriteNode) {
		doEnemyExplosion(enemy)
		playExplotionSound()
	}
	
	internal func getShootAktion()-> SKAction {
		let showSpeedShoot = self.enemySpeed / 2
		let enemyShootAction:SKAction = SKAction.customAction(withDuration: TimeInterval(self.showEnemySpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(showSpeedShoot) && self.enemySpaceShipShoot!.isShootEnabled) {
				self.addShoot();
			}
		})
		
		return enemyShootAction
	}
	
	internal override func addShoot() {
		self.enemySpaceShipShoot!.isShootEnabled = false;
		self.enemySpaceShipShoot!.addShoot(self.spaceShip);
	}
}
