//
//  GameScene.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 11/5/16.
//  Copyright (c) 2016 Maximiliano. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	fileprivate var userSpaceShip: UserSpaceShip?
	fileprivate var ufoSpaceShip: UfoSpaceShip?
	fileprivate var enemySpaceShip: EnemySpaceShip?
	fileprivate var userLife: UserLife?
	
	
	fileprivate var pointsCounter:SKLabelNode = SKLabelNode()//fontNamed:"Chalkduster")
	fileprivate let separator = 50
	fileprivate let menuBackName = "MenuBack"
	fileprivate let shootButtonName = "ShootButtonName"
	fileprivate let userSpaceShipName = "UserSpaceShipName"
	fileprivate let hitsLabelText:String = "Hits:"
	fileprivate var hitsLabelPoints:Int = 0
	fileprivate var fingureIsOnUserSpaceShip = false
	
	override func didMove(to view: SKView) {
		self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
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
		self.addShootButtons()
	}
	
	fileprivate func addShootButtons() {
		addShootButton(Int(self.frame.maxX) - separator)
		addShootButton(Int(self.frame.minX) + separator)
	}
	
	fileprivate func addShootButton(_ x: Int) {
		let shootButton = SKSpriteNode(imageNamed: "shootButton")
		
		shootButton.name = shootButtonName
		shootButton.setScale(0.5)
		shootButton.position = CGPoint(x: x, y: Int(self.frame.minY) + separator)
		
		self.addChild(shootButton)
	}
	
	fileprivate func addPointsCounter() {
		let pointsText = NSString(format: "%03d", hitsLabelPoints)
		
		pointsCounter.fontName = "Apple Color Emoji"
		pointsCounter.text = "\(hitsLabelText)\(pointsText)"
		pointsCounter.fontSize = 22
		pointsCounter.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
		pointsCounter.position = CGPoint(x: Int(Double(self.frame.width) - (Double(separator) * 1.5)), y: Int(self.frame.height) - (separator / 2))
		
		self.addChild(pointsCounter)
	}
	
	fileprivate func addMenuBack() {
		let menuBack = SKLabelNode()
		
		menuBack.fontName = "Apple Color Emoji"
		menuBack.text = "Menu"
		menuBack.name = menuBackName
		menuBack.fontSize = 22
		menuBack.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
		menuBack.position = CGPoint(x: Int(self.frame.midX) - (separator / 5), y: Int(self.frame.height) - (separator / 2))
		
		self.addChild(menuBack)
	}
	
	fileprivate func loaBackgroundSounds() {
		let backgroundMusic = SKAudioNode(fileNamed: "engine.wav")
		backgroundMusic.autoplayLooped = true
		
		self.addChild(backgroundMusic)
	}
	
	fileprivate func setBackgroundImage() {
		let spaceBackground = SKSpriteNode(imageNamed:"SpaceBackground")
		spaceBackground.zPosition = -1000
		spaceBackground.position = CGPoint (x: self.frame.midX, y: self.frame.midY)
		spaceBackground.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
		
		backgroundColor = SKColor.black
		addChild(spaceBackground)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)
			
			if let elementName = self.atPoint(location).name {
				if (elementName == menuBackName) {
					self.didMenu()
				}
				else if (elementName == shootButtonName) {
					self.userSpaceShip!.addShoot()
				}
				else if (elementName == userSpaceShipName) {
					if (self.atPoint(location) == self.userSpaceShip!.spaceShip) {
						self.fingureIsOnUserSpaceShip = true
					}
				}
				
				return
			}
			
			/*
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
			*/
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.fingureIsOnUserSpaceShip = true
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.fingureIsOnUserSpaceShip = true
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if (self.fingureIsOnUserSpaceShip) {
			if let touch = touches.first as UITouch? {
				let touchLoc = touch.location(in: self)
				let prevTouchLoc = touch.previousLocation(in: self)
				//let ninja = self.childNodeWithName(playCategoryName) as! SKSpriteNode
				var newYPos = self.userSpaceShip!.position.y + (touchLoc.y - prevTouchLoc.y)
				var newXPos = self.userSpaceShip!.position.x + (touchLoc.x - prevTouchLoc.x)
				
				newYPos = max(newYPos, self.userSpaceShip!.size.height / 2)
				newYPos = min(newYPos, self.size.height - self.userSpaceShip!.size.height / 2)
				
				newXPos = max(newXPos, self.userSpaceShip!.size.width / 2)
				newXPos = min(newXPos, self.size.width - self.userSpaceShip!.size.width / 2)
				
				//set new X and Y for your sprite.
				self.userSpaceShip!.position = CGPoint(x: newXPos, y: newYPos)
			}
		}
	}
	
	fileprivate func didMenu() {
		if let scene = GameStartScene(fileNamed:"GameStartScene") {
			scene.size = self.size
			scene.scaleMode = .aspectFill
			
			self.removeAllActions()
			self.removeAllChildren()
			let transition = SKTransition.fade(withDuration: 2)
			
			self.view?.presentScene(scene, transition: transition)
		}
	}
	
	override func update(_ currentTime: TimeInterval) {
	}
	
	internal func didBegin(_ contact: SKPhysicsContact) {
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
				
				if ((firstBody!.categoryBitMask & PhysicsCategory.userShip.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.ufo.rawValue != 0)) {
					self.userSpaceShip!.doShipExplotion()
					self.ufoSpaceShip!.ufoDidCollideWithShip(enemyObject)
					self.removeUserLife()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.userShip.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.enemy.rawValue != 0)) {
					self.userSpaceShip!.doShipExplotion()
					self.enemySpaceShip!.enemyDidCollideWithShip(enemyObject)
					self.removeUserLife()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.userShip.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.enemyShot.rawValue != 0)) {
					self.userSpaceShip!.doShipExplotion()
					self.removeUserLife()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.shot.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.enemy.rawValue != 0)) {
					self.userSpaceShip!.disposeShot(userObject)
					self.enemySpaceShip!.projectileDidCollideWithEnemy(userObject, enemy: enemyObject)
					self.enemyHitted()
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.shot.rawValue != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.ufo.rawValue != 0)) {
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
	
	fileprivate func removeUserLife() {
		if(self.userLife!.removeUserLife() <= 0) {
			self.didLose()
		}
	}
	
	fileprivate func enemyHitted() {
		self.addPointsToHits(1)
		self.didWon()
	}
	
	fileprivate func ufoHitted() {
		self.addPointsToHits(3)
		self.didWon()
	}
	
	fileprivate func didLose() {
		if let scene = GameLostScene(fileNamed:"GameLostScene") {
			scene.size = self.size
			scene.scaleMode = .aspectFill
			self.removeAllActions()
			self.removeAllChildren()
			
			let transition = SKTransition.fade(withDuration: 2)
			self.view?.presentScene(scene, transition: transition)
		}
	}
	
	fileprivate func addPointsToHits(_ points:Int) {
		hitsLabelPoints += points
		let pointsText = NSString(format: "%03d", hitsLabelPoints)
		
		pointsCounter.text = "\(hitsLabelText) \(pointsText)"
	}
	
	fileprivate func didWon() {
		if(hitsLabelPoints >= 100) {
			if let scene = GameWonScene(fileNamed:"GameWonScene") {
				scene.size = self.size
				scene.scaleMode = .aspectFill
				self.removeAllActions()
				self.removeAllChildren()
				
				let transition = SKTransition.fade(withDuration: 2)
				self.view?.presentScene(scene, transition: transition)
			}
		}
	}
}
