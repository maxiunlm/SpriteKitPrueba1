//
//  UserShip.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 10/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


open class UserSpaceShip: SpaceShipBase {
	fileprivate var userSpaceShipShoot: UserSpaceShipShoot?
	fileprivate var _yUserShipPosition : CGFloat?
	fileprivate let userSpaceShipName = "UserSpaceShipName"
	fileprivate let separator = 50
	open let spaceShipQuiet: SKTexture = SKTexture(imageNamed:"UserShip")
	open let spaceShipToLeft: SKTexture = SKTexture(imageNamed:"UserShipToLeft")
	open let spaceShipToRight: SKTexture = SKTexture(imageNamed:"UserShipToRight")
	
	open var position: CGPoint {
		get {
			return self.spaceShip.position
		}
		set{
			self.spaceShip.position = newValue
		}
	}
	open var texture: SKTexture {
		get {
			return self.spaceShip.texture!
		}
		set{
			self.spaceShip.texture = newValue
		}
	}
	
	open var yUserShipPosition : CGFloat {
		get {
			return self._yUserShipPosition!
		}
	}
	open var size : CGSize {
		get {
			return self.spaceShip.size
		}
	}
	open var isShotEnabled: Bool {
		get {
			return self.userSpaceShipShoot!.isShootEnabled
		}
	}
	
	
	public override init(gameScene: SKScene) {
		super.init(gameScene: gameScene)
		
		self.spaceShip = SKSpriteNode(imageNamed:"UserShip")
		self._yUserShipPosition = self.gameScene.frame.minY + CGFloat(separator)
		self.userSpaceShipShoot = UserSpaceShipShoot(gameScene: self.gameScene, userSpaceShip: self.spaceShip)
	}
	
	open func doShipExplotion() {
		self.userSpaceShipShoot!.isShootEnabled = false
		let path = Bundle.main.path(forResource: "ShipExplotionParticle", ofType: "sks")
		let shipExplotionParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
		
		shipExplotionParticle.xScale = self.spaceShipScale / 2
		shipExplotionParticle.yScale = self.spaceShipScale / 2
		shipExplotionParticle.position = spaceShip.position
		shipExplotionParticle.name = "shipExplotionParticle"
		shipExplotionParticle.targetNode = self.gameScene.scene
		shipExplotionParticle.zPosition = 1000
		
		let hiddenShipAction:SKAction = SKAction.customAction(withDuration: TimeInterval(self.spaceShipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			self.spaceShip.position = CGPoint(x: -self.gameScene.frame.maxX, y: -self.gameScene.frame.maxY)
		})
		let showShipAction:SKAction = SKAction.customAction(withDuration: TimeInterval(self.spaceShipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.spaceShipExplosionTime) && elapsedTime > CGFloat(self.userSpaceShipShoot!.shottingSpeed) * 2) {
				self.spaceShip.position = CGPoint(x: self.gameScene.frame.midX, y: self.yUserShipPosition)
				self.userSpaceShipShoot!.isShootEnabled = true
			}
		})
		self.gameScene.addChild(shipExplotionParticle)
		
		shipExplotionParticle.run(SKAction.sequence([hiddenShipAction, SKAction.wait(forDuration: 1), showShipAction, SKAction.removeFromParent()]))
	}
	
	open override func addShoot() {
		if(self.userSpaceShipShoot!.isShootEnabled == true) {
			self.userSpaceShipShoot!.addShoot();
		}
	}
	
	open func createSpaceShip() -> SKSpriteNode {
		let location = CGPoint(x: self.gameScene.frame.midX, y: self.yUserShipPosition)
		
		self.spaceShip.xScale = self.spaceShipScale
		self.spaceShip.yScale = self.spaceShipScale
		self.position = location
		self.spaceShip.zPosition = 500
		self.spaceShip.name = self.userSpaceShipName
		
		self.spaceShip.physicsBody = SKPhysicsBody(circleOfRadius: spaceShip.size.width / 2)
		self.spaceShip.physicsBody?.isDynamic = true
		self.spaceShip.physicsBody?.categoryBitMask = PhysicsCategory.userShip.rawValue
		self.spaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue + PhysicsCategory.ufo.rawValue
		self.spaceShip.physicsBody?.collisionBitMask = PhysicsCategory.none.rawValue
		self.spaceShip.physicsBody?.usesPreciseCollisionDetection = true
		
		return spaceShip
	}
	
	open func disposeShot(_ shot: SKSpriteNode) {
		self.userSpaceShipShoot!.disposeShot(shot)
	}
}
