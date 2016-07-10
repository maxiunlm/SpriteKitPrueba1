//
//  UserShip.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 10/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import SpriteKit
import Foundation

public class UserSpaceShip {
	internal var userSpaceShip: SKSpriteNode = SKSpriteNode(imageNamed:"UserShip")
	
	private var _yUserShipPosition : CGFloat
	private var userSpaceShipExplosionImages: [SKTexture] = []
	internal var frame: CGRect
	
	
	public let userSpaceShipQuiet: SKTexture = SKTexture(imageNamed:"UserShip")
	public let userSpaceShipToLeft: SKTexture = SKTexture(imageNamed:"UserShipToLeft")
	public let userSpaceShipToRight: SKTexture = SKTexture(imageNamed:"UserShipToRight")
	public let userShipScale: CGFloat = CGFloat(0.8)
	public let userSpaceShipExplosionTime: NSTimeInterval = NSTimeInterval(1)
	public var position: CGPoint {
		get {
			return self.userSpaceShip.position
		}
		set{
			self.userSpaceShip.position = newValue
		}
	}
	public var texture: SKTexture {
		get {
			return self.userSpaceShip.texture!
		}
		set{
			self.userSpaceShip.texture = newValue
		}
	}
	public var yUserShipPosition : CGFloat {
		get {
			return self._yUserShipPosition
		}
	}
	public var size : CGSize {
		get {
			return self.userSpaceShip.size
		}
	}
	
	
	public init(frame: CGRect) {
		self.frame = frame
		self._yUserShipPosition = CGRectGetMidY(self.frame) / 3 + 25
		
		self.loadExplosions()
	}
	
	
	
	public func createUserSpaceShip() -> SKSpriteNode {
		let location = CGPoint(x: CGRectGetMidX(self.frame), y: self.yUserShipPosition)
		
		self.userSpaceShip.xScale = userShipScale
		self.userSpaceShip.yScale = userShipScale
		self.position = location
		self.userSpaceShip.zPosition = 500
		
		self.userSpaceShip.physicsBody = SKPhysicsBody(circleOfRadius: userSpaceShip.size.width / 2)
		self.userSpaceShip.physicsBody?.dynamic = true
		self.userSpaceShip.physicsBody?.categoryBitMask = PhysicsCategory.UserShip.rawValue
		self.userSpaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy.rawValue + PhysicsCategory.UFO.rawValue
		self.userSpaceShip.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
		self.userSpaceShip.physicsBody?.usesPreciseCollisionDetection = true
		
		//self.addChild(userSpaceShip)
		
		return userSpaceShip
	}
	
	
	private func loadExplosions() {
		for imageFrame in 0...281 {
			let indexImage:String = String(format: "%03d", imageFrame)
			let imagePath: String = "shipexplosion0\( indexImage )"
			let image: SKTexture = SKTexture(imageNamed: imagePath)
			
			self.userSpaceShipExplosionImages.append(image)
		}
	}
	
	public func runAction(action: SKAction, completion block: () -> Void){
		self.userSpaceShip.runAction(action, completion: block)
	}
}