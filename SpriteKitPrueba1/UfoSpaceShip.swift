//
//  UfoSpaceShip.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 22/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import SpriteKit
import Foundation


open class UfoSpaceShip: EnemySpaceShipBase {
	fileprivate var ufoSpaceShipShoot: UfoSpaceShipShoot?
	fileprivate var userSpaceShip: SKSpriteNode
	fileprivate let showSpeed = 3
	fileprivate let ufoAngularSpeed = 2
	fileprivate let speed = 5
	
	public init(gameScene: SKScene, userSpaceShip: SKSpriteNode) {
		self.userSpaceShip = userSpaceShip
		super.init(gameScene: gameScene)

		self.ufoSpaceShipShoot = UfoSpaceShipShoot(gameScene: self.gameScene, userSpaceShip: self.userSpaceShip)
		self.explotionFileName = "ufoexplosion"
		self.maxExplotionImageIndex = 307
		self.loadExplosions()
		self.addSpaceShip()
	}
	
	internal override func addSpaceShip() {
		self.ufoSpaceShipShoot!.isShootEnabled = true;
		let yPosition: CGFloat = MathHelper.random(min: self.gameScene.frame.midY - 50, max: self.gameScene.frame.maxY + 150)
		let location = CGPoint(x: self.gameScene.frame.minX - 50, y: yPosition)
		self.spaceShip = SKSpriteNode(imageNamed:"UFOShip")
		
		self.spaceShip.xScale = self.spaceShipScale
		self.spaceShip.yScale = self.spaceShipScale
		self.spaceShip.position = location
		self.spaceShip.zPosition = 100
		
		self.spaceShip.physicsBody = SKPhysicsBody(circleOfRadius: spaceShip.size.width / 2)
		self.spaceShip.physicsBody?.isDynamic = true
		self.spaceShip.physicsBody?.categoryBitMask = PhysicsCategory.ufo.rawValue
		self.spaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.shot.rawValue
		self.spaceShip.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
		self.spaceShip.physicsBody?.usesPreciseCollisionDetection = false
		
		self.gameScene.addChild(self.spaceShip)
		
		let rotateAction = SKAction.rotate(byAngle: CGFloat(M_2_PI), duration: TimeInterval(ufoAngularSpeed))
		self.spaceShip.run(SKAction.repeatForever(rotateAction))
		
		let anotherUfoAction:SKAction = getAddspaceShipAction()
		let path:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: location.x, y: -yPosition), radius: yPosition, startAngle: CGFloat(M_PI_2), endAngle: -CGFloat(M_PI_4 / 2), clockwise: false)
		let moveAction = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, duration: 5.0)
		let shootAktion = self.getShootAktion()
		
		self.spaceShip.run(SKAction.sequence([SKAction.wait(forDuration: 1), moveAction, anotherUfoAction, SKAction.removeFromParent()]))
		
		self.gameScene.run(shootAktion)
	}
	
	fileprivate func getAddspaceShipAction() -> SKAction {
		let anotherUfoAction:SKAction = SKAction.customAction(withDuration: TimeInterval(self.showSpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.showSpeed)) {
				self.addSpaceShip()
			}
		})
		
		return anotherUfoAction
	}
	
	open func ufoDidCollideWithShip(_ ufo: SKSpriteNode) {
		playExplotionSound()
	}
	
	open func projectileDidCollideWithUFO(_ shot: SKSpriteNode, ufo: SKSpriteNode) {
		doUfoExplosion(ufo)
		playExplotionSound()
	}
	
	fileprivate func doUfoExplosion(_ ufo: SKSpriteNode) {
		ufo.removeAllActions()
		ufo.isHidden = false
		ufo.physicsBody = nil
		let position:CGPoint = ufo.position
		ufo.position = CGPoint(x: -self.gameScene.frame.midX, y: -self.gameScene.frame.maxY)
		ufo.removeFromParent()
		
		
		let fakeSpaceShip: SKSpriteNode = SKSpriteNode(imageNamed:"UFOShip")
		fakeSpaceShip.xScale = spaceShipScale
		fakeSpaceShip.yScale = spaceShipScale
		fakeSpaceShip.position = position
		fakeSpaceShip.zPosition = 1000
		self.gameScene.addChild(fakeSpaceShip)
		
		fakeSpaceShip.run(SKAction.fadeOut(withDuration: 0.35), completion: {() -> Void in
			fakeSpaceShip.isHidden = true
			fakeSpaceShip.removeFromParent()
		})
		
		let ufoExplotion: SKSpriteNode = SKSpriteNode()
		ufoExplotion.texture = spaceShipExplosionImages[0]
		ufoExplotion.position = position
		ufoExplotion.size.height = ufo.size.height * 3
		ufoExplotion.size.width = ufo.size.height * 3
		ufoExplotion.zPosition = 900
		self.gameScene.addChild(ufoExplotion)
		
		let animateExplosion = SKAction.animate(with: spaceShipExplosionImages, timePerFrame: timePerFrameAnimation)
		ufoExplotion.run(animateExplosion, completion:  {() -> Void in
			ufoExplotion.removeFromParent()
			self.addSpaceShip()
		})
	}
	
	internal func getShootAktion()-> SKAction {
		let ufoShootAction:SKAction = SKAction.customAction(withDuration: TimeInterval(self.showSpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.showSpeed) && self.ufoSpaceShipShoot!.isShootEnabled) {
				self.addShoot();
			}
		})
		
		return ufoShootAction
	}
	
	internal override func addShoot() {
		self.ufoSpaceShipShoot!.isShootEnabled = false;
		self.ufoSpaceShipShoot!.addShoot(self.spaceShip);
	}
}
