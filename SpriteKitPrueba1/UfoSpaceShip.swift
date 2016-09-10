//
//  UfoSpaceShip.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 22/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import SpriteKit
import Foundation


public class UfoSpaceShip: EnemySpaceShipBase {
	private var ufoSpaceShipShoot: UfoSpaceShipShoot?
	private var userSpaceShip: SKSpriteNode
	private let showSpeed = 3
	private let ufoAngularSpeed = 2
	private let speed = 5
	
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
		let yPosition: CGFloat = MathHelper.random(min: CGRectGetMidY(self.gameScene.frame) - 50, max: CGRectGetMaxY(self.gameScene.frame) + 150)
		let location = CGPoint(x: CGRectGetMinX(self.gameScene.frame) - 50, y: yPosition)
		self.spaceShip = SKSpriteNode(imageNamed:"UFOShip")
		
		self.spaceShip.xScale = self.spaceShipScale
		self.spaceShip.yScale = self.spaceShipScale
		self.spaceShip.position = location
		self.spaceShip.zPosition = 100
		
		self.spaceShip.physicsBody = SKPhysicsBody(circleOfRadius: spaceShip.size.width / 2)
		self.spaceShip.physicsBody?.dynamic = true
		self.spaceShip.physicsBody?.categoryBitMask = PhysicsCategory.UFO.rawValue
		self.spaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.Shot.rawValue
		self.spaceShip.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
		self.spaceShip.physicsBody?.usesPreciseCollisionDetection = false
		
		self.gameScene.addChild(self.spaceShip)
		
		let rotateAction = SKAction.rotateByAngle(CGFloat(M_2_PI), duration: NSTimeInterval(ufoAngularSpeed))
		self.spaceShip.runAction(SKAction.repeatActionForever(rotateAction))
		
		let anotherUfoAction:SKAction = getAddspaceShipAction()
		let path:UIBezierPath = UIBezierPath(arcCenter: CGPointMake(location.x, -yPosition), radius: yPosition, startAngle: CGFloat(M_PI_2), endAngle: -CGFloat(M_PI_4 / 2), clockwise: false)
		let moveAction = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: true, duration: 5.0)
		let shootAktion = self.getShootAktion()
		
		self.spaceShip.runAction(SKAction.sequence([SKAction.waitForDuration(1), moveAction, anotherUfoAction, SKAction.removeFromParent()]))
		
		self.gameScene.runAction(shootAktion)
	}
	
	private func getAddspaceShipAction() -> SKAction {
		let anotherUfoAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(self.showSpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.showSpeed)) {
				self.addSpaceShip()
			}
		})
		
		return anotherUfoAction
	}
	
	public func ufoDidCollideWithShip(ufo: SKSpriteNode) {
		playExplotionSound()
	}
	
	public func projectileDidCollideWithUFO(shot: SKSpriteNode, ufo: SKSpriteNode) {
		doUfoExplosion(ufo)
		playExplotionSound()
	}
	
	private func doUfoExplosion(ufo: SKSpriteNode) {
		ufo.removeAllActions()
		ufo.hidden = false
		ufo.physicsBody = nil
		let position:CGPoint = ufo.position
		ufo.position = CGPoint(x: -CGRectGetMidX(self.gameScene.frame), y: -CGRectGetMaxY(self.gameScene.frame))
		ufo.removeFromParent()
		
		
		let fakeSpaceShip: SKSpriteNode = SKSpriteNode(imageNamed:"UFOShip")
		fakeSpaceShip.xScale = spaceShipScale
		fakeSpaceShip.yScale = spaceShipScale
		fakeSpaceShip.position = position
		fakeSpaceShip.zPosition = 1000
		self.gameScene.addChild(fakeSpaceShip)
		
		fakeSpaceShip.runAction(SKAction.fadeOutWithDuration(0.35), completion: {() -> Void in
			fakeSpaceShip.hidden = true
			fakeSpaceShip.removeFromParent()
		})
		
		let ufoExplotion: SKSpriteNode = SKSpriteNode()
		ufoExplotion.texture = spaceShipExplosionImages[0]
		ufoExplotion.position = position
		ufoExplotion.size.height = ufo.size.height * 3
		ufoExplotion.size.width = ufo.size.height * 3
		ufoExplotion.zPosition = 900
		self.gameScene.addChild(ufoExplotion)
		
		let animateExplosion = SKAction.animateWithTextures(spaceShipExplosionImages, timePerFrame: timePerFrameAnimation)
		ufoExplotion.runAction(animateExplosion, completion:  {() -> Void in
			ufoExplotion.removeFromParent()
			self.addSpaceShip()
		})
	}
	
	internal func getShootAktion()-> SKAction {
		let ufoShootAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(self.showSpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
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