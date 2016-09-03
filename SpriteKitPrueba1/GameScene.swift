//
//  GameScene.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 11/5/16.
//  Copyright (c) 2016 Maximiliano. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	private var userSpaceShip: UserSpaceShip?
	private var ufoSpaceShip: UfoSpaceShip?
	private var enemySpaceShip: EnemySpaceShip?
	private var userLife: UserLife?
	
	
	private var pointsCounter:SKLabelNode = SKLabelNode()//fontNamed:"Chalkduster")
	private let separator = 50
	private let menuBackName = "MenuBack"
	private let shootButtonName = "ShootButtonName"
	private let hitsLabelText:String = "Hits:"
	private var hitsLabelPoints:Int = 0	
	
	override func didMoveToView(view: SKView) {
		self.physicsWorld.gravity = CGVectorMake(0, 0)
		self.physicsWorld.contactDelegate = self
		self.setBackgroundImage()
		
		self.addPointsCounter()
		self.addMenuBack()
		
		self.userSpaceShip = UserSpaceShip(gameScene: self)
		self.addChild(self.userSpaceShip!.createSpaceShip())
		self.userLife = UserLife(gameScene: self, userSpaceShip: self.userSpaceShip!)
		self.userLife!.addUserLifes()
		
		self.ufoSpaceShip = UfoSpaceShip(gameScene: self, userSpaceShip: self.userSpaceShip!.spaceShip)
		self.enemySpaceShip = EnemySpaceShip(gameScene: self)
		self.loaBackgroundSounds()
		self.addShootButton()
	}
	
	private func addShootButton() {
		let shootButton = SKSpriteNode(imageNamed: "shootButton")
		
		shootButton.name = shootButtonName
		shootButton.setScale(0.5)
		shootButton.position = CGPoint(x: Int(self.frame.maxX) - separator, y: Int(self.frame.minY) + separator)

		self.addChild(shootButton)
	}

	private func addPointsCounter() {
		let pointsText = NSString(format: "%03d", hitsLabelPoints)
		
		pointsCounter.fontName = "Apple Color Emoji"
		pointsCounter.text = "\(hitsLabelText) \(pointsText)"
		pointsCounter.fontSize = 22
		pointsCounter.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
		pointsCounter.position = CGPoint(x: Int(self.frame.width) - (separator * 2), y: Int(self.frame.height) - (separator / 2))
		
		self.addChild(pointsCounter)
	}
	
	private func addMenuBack() {
		let menuBack = SKLabelNode()
		
		menuBack.fontName = "Apple Color Emoji"
		menuBack.text = "Menu"// \(self.size.width)x\(self.size.height)"
		menuBack.name = menuBackName
		menuBack.fontSize = 22
		menuBack.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
		menuBack.position = CGPoint(x: Int(self.frame.midX) - (separator / 6), y: Int(self.frame.height) - (separator / 2))
		
		self.addChild(menuBack)
	}
	
	private func loaBackgroundSounds() {
		//		let backgroundMusic = SKAudioNode(fileNamed: "engine.wav")
		//		backgroundMusic.autoplayLooped = true
		//		addChild(backgroundMusic)
	}
	
	private func setBackgroundImage() {
		let spaceBackground = SKSpriteNode(imageNamed:"SpaceBackground")
		spaceBackground.zPosition = -1000
		spaceBackground.position = CGPoint (x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
		spaceBackground.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
		
		backgroundColor = SKColor.blackColor()
		addChild(spaceBackground)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			let location = touch.locationInNode(self)
			
			if let elementName = self.nodeAtPoint(location).name {
				if elementName == menuBackName {
					self.didMenu()
				}
				else if elementName == shootButtonName {
					self.userSpaceShip!.addShoot()
				}

				return
			}
			
			let duration: Double = abs(Double((userSpaceShip!.position.x - location.x) / (CGRectGetWidth(self.frame) * 2)))
			
			if(self.userSpaceShip!.position.x - location.x > 0) {
				self.userSpaceShip!.texture = self.userSpaceShip!.spaceShipToLeft
			} else {
				self.userSpaceShip!.texture = self.userSpaceShip!.spaceShipToRight
			}
			
			let action = SKAction.moveToX(location.x, duration: duration)
			
			self.userSpaceShip!.runAction(action, completion: {() -> Void in
				self.userSpaceShip!.texture = self.userSpaceShip!.spaceShipQuiet
			})
		}
	}
	
	private func didMenu() {
		if let scene = GameStartScene(fileNamed:"GameStartScene") {
			scene.size = self.size
			scene.scaleMode = .AspectFill
			
			self.removeAllActions()
			self.removeAllChildren()
			let transition = SKTransition.fadeWithDuration(2)
			
			self.view?.presentScene(scene, transition: transition)
		}
	}
	
	override func update(currentTime: CFTimeInterval) {
	}
	
	internal func didBeginContact(contact: SKPhysicsContact) {
		do {
			var firstBody: SKPhysicsBody?
			var secondBody: SKPhysicsBody?
			if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
				firstBody = contact.bodyA
				secondBody = contact.bodyB
			} else {
				firstBody = contact.bodyB
				secondBody = contact.bodyA
			}
			
			if (firstBody!.node != nil && secondBody!.node != nil) {
				let enemyObject: SKSpriteNode = secondBody!.node as! SKSpriteNode
				let userObject: SKSpriteNode = firstBody!.node as! SKSpriteNode
				
				if ((firstBody!.categoryBitMask & PhysicsCategory.UserShip.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.UFO.rawValue != 0)) {
					self.userSpaceShip!.doShipExplotion()
					self.ufoSpaceShip!.ufoDidCollideWithShip(enemyObject)
					self.removeUserLife()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.UserShip.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.Enemy.rawValue != 0)) {
					self.userSpaceShip!.doShipExplotion()
					self.enemySpaceShip!.enemyDidCollideWithShip(enemyObject)
					self.removeUserLife()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.UserShip.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.EnemyShot.rawValue != 0)) {
					self.userSpaceShip!.doShipExplotion()
					self.removeUserLife()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.Shot.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.Enemy.rawValue != 0)) {
					self.userSpaceShip!.disposeShot(userObject)
					self.enemySpaceShip!.projectileDidCollideWithEnemy(userObject, enemy: enemyObject)
					self.enemyHitted()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.Shot.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.UFO.rawValue != 0)) {
					self.userSpaceShip!.disposeShot(userObject)
					self.ufoSpaceShip!.projectileDidCollideWithUFO(userObject, ufo: enemyObject)
					self.ufoHitted()
				}
			}
		}
		//		catch let error as NSError {
		//			print("Unexpected ERROR \( error.description )")
		//		}
	}
	
	private func removeUserLife() {
		if(self.userLife!.removeUserLife() <= 0) {
			self.didLose()
		}
	}
	
	private func enemyHitted() {
		self.addPointsToHits(1)
		self.didWon()
	}
	
	private func ufoHitted() {
		self.addPointsToHits(3)
		self.didWon()
	}
	
	private func didLose() {
		if let scene = GameLostScene(fileNamed:"GameLostScene") {
			scene.size = self.size
			scene.scaleMode = .AspectFill
			self.removeAllActions()
			self.removeAllChildren()
			
			let transition = SKTransition.fadeWithDuration(2)
			self.view?.presentScene(scene, transition: transition)
		}
	}
	
	private func addPointsToHits(points:Int) {
		hitsLabelPoints += points
		let pointsText = NSString(format: "%03d", hitsLabelPoints)
		
		pointsCounter.text = "\(hitsLabelText) \(pointsText)"
	}
	
	private func didWon() {
		if(hitsLabelPoints >= 100) {
			if let scene = GameWonScene(fileNamed:"GameWonScene") {
				scene.size = self.size
				scene.scaleMode = .AspectFill
				self.removeAllActions()
				self.removeAllChildren()
				
				let transition = SKTransition.fadeWithDuration(2)
				self.view?.presentScene(scene, transition: transition)
			}
		}
	}
}
