//
//  UserShip.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 10/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


public class UserSpaceShip: SpaceShipBase {
	private var userSpaceShipShot: UserSpaceShipShot?
	private var _yUserShipPosition : CGFloat?
	public let spaceShipQuiet: SKTexture = SKTexture(imageNamed:"UserShip")
	public let spaceShipToLeft: SKTexture = SKTexture(imageNamed:"UserShipToLeft")
	public let spaceShipToRight: SKTexture = SKTexture(imageNamed:"UserShipToRight")
	
	public var position: CGPoint {
		get {
			return self.spaceShip.position
		}
		set{
			self.spaceShip.position = newValue
		}
	}
	public var texture: SKTexture {
		get {
			return self.spaceShip.texture!
		}
		set{
			self.spaceShip.texture = newValue
		}
	}
	
	public var yUserShipPosition : CGFloat {
		get {
			return self._yUserShipPosition!
		}
	}
	public var size : CGSize {
		get {
			return self.spaceShip.size
		}
	}
	public var isShotEnabled: Bool {
		get {
			return self.userSpaceShipShot!.isShotEnabled
		}
	}
	
	
	public override init(gameScene: SKScene) {
		super.init(gameScene: gameScene)
		
		self.spaceShip = SKSpriteNode(imageNamed:"UserShip")
		self._yUserShipPosition = CGRectGetMidY(self.gameScene.frame) / 3 + 25
		self.userSpaceShipShot = UserSpaceShipShot(gameScene: self.gameScene, userSpaceShip: self.spaceShip)
	}
	
	public func doShipExplotion() {
		self.userSpaceShipShot!.isShotEnabled = false
		let path = NSBundle.mainBundle().pathForResource("ShipExplotionParticle", ofType: "sks")
		let shipExplotionParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
		
		shipExplotionParticle.position = spaceShip.position
		shipExplotionParticle.name = "shipExplotionParticle"
		shipExplotionParticle.targetNode = self.gameScene.scene
		shipExplotionParticle.zPosition = 1000
		
		let hiddenShipAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(self.spaceShipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			self.spaceShip.position = CGPoint(x: -CGRectGetMaxX(self.gameScene.frame), y: -CGRectGetMaxY(self.gameScene.frame))
		})
		let showShipAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(self.spaceShipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.spaceShipExplosionTime) && elapsedTime > CGFloat(self.userSpaceShipShot!.shottingSpeed) * 2) {
				self.spaceShip.position = CGPoint(x: CGRectGetMidX(self.gameScene.frame), y: self.yUserShipPosition)
				self.userSpaceShipShot!.isShotEnabled = true
				self.userSpaceShipShot!.addShot();
			}
		})
		self.gameScene.addChild(shipExplotionParticle)
		
		shipExplotionParticle.runAction(SKAction.sequence([hiddenShipAction, SKAction.waitForDuration(1), showShipAction, SKAction.removeFromParent()]))
	}
	
	public func createSpaceShip() -> SKSpriteNode {
		let location = CGPoint(x: CGRectGetMidX(self.gameScene.frame), y: self.yUserShipPosition)
		
		self.spaceShip.xScale = self.spaceShipScale
		self.spaceShip.yScale = self.spaceShipScale
		self.position = location
		self.spaceShip.zPosition = 500
		
		self.spaceShip.physicsBody = SKPhysicsBody(circleOfRadius: spaceShip.size.width / 2)
		self.spaceShip.physicsBody?.dynamic = true
		self.spaceShip.physicsBody?.categoryBitMask = PhysicsCategory.UserShip.rawValue
		self.spaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy.rawValue + PhysicsCategory.UFO.rawValue
		self.spaceShip.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
		self.spaceShip.physicsBody?.usesPreciseCollisionDetection = true
		
		//self.addChild(spaceShip)
		
		return spaceShip
	}
	
	public func disposeShot(shot: SKSpriteNode) {
		self.userSpaceShipShot!.disposeShot(shot)
	}
}