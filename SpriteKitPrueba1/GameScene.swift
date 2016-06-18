//
//  GameScene.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 11/5/16.
//  Copyright (c) 2016 Maximiliano. All rights reserved.
//

import SpriteKit
import Darwin

class GameScene: SKScene, SKPhysicsContactDelegate {
	private struct PhysicsCategory {
		static let None			: UInt32 = 0
		static let All				: UInt32 = UInt32.max
		static let UserShip		: UInt32 = 0b1			//  1
		static let Shot			: UInt32 = 0b10			//  2
		static let EnemyShot    : UInt32 = 0b100		//  4
		static let Enemy			: UInt32 = 0b1000		//  8
		static let UFO				: UInt32 = 0b10000		// 16
	}

	private var userSpaceShip: SKSpriteNode = SKSpriteNode()
	private var yUserShipPosition : CGFloat = 0
	private var userSpaceShipQuiet: SKTexture = SKTexture(imageNamed:"UserShip")
	private var userSpaceShipToLeft: SKTexture = SKTexture(imageNamed:"UserShipToLeft")
	private var userSpaceShipToRight: SKTexture = SKTexture(imageNamed:"UserShipToRight")


	private let showUfoSpeed = 3
	private let ufoAngularSpeed = 2
	private let ufoSpeed = 5
	private let userShipScale:CGFloat = CGFloat(1.0)
	private let ufoShipScale:CGFloat = CGFloat(1.0)
	private var ufoExplosionImages: [SKTexture] = []
	private var ufoSemaphore = dispatch_semaphore_create(0)

	private let showEnemySpeed = 3
	private let enemySpeed = 5
	private let enemyShipScale:CGFloat = CGFloat(1.0)
	private var enemyExplosionImages: [SKTexture] = []
	private var enemySemaphore = dispatch_semaphore_create(0)
	private let enemyShipRunActionKey: String = "enemyShip.runAction-Key"

	private let shotScale:CGFloat = CGFloat(0.5)
	private let shottingSpeed = 0.3
	private var isShotEnabled = true
	private var pointsCounter:SKLabelNode = SKLabelNode()//fontNamed:"Chalkduster")
	private let userLifesMaxCount = 3
	private var userLifesCounter = 3
	private var userLifeShips:[SKSpriteNode] = []
	private let separator = 50
	private let menuBackName = "MenuBack"
	private let hitsLabelText:String = "Hits:"
	private var hitsLabelPoints:Int = 0
	private var shipExplosionTime: NSTimeInterval = NSTimeInterval(1)
	private var shipExplosionImages: [SKTexture] = []

	private let timeForExplotionSound: NSTimeInterval = NSTimeInterval(5)
	private let timePerFrameAnimation: NSTimeInterval = NSTimeInterval(0.025)

	override func didMoveToView(view: SKView) {
		self.physicsWorld.gravity = CGVectorMake(0, 0)
		self.physicsWorld.contactDelegate = self
		self.yUserShipPosition = CGRectGetMidY(self.frame) / 4
		self.setBackgroundImage()

		self.addPointsCounter()
		self.addMenuBack()
		self.addUserLifes()
		self.addSpaceShip()
		self.loadExplosions()
		self.addEnemyShip()
		self.addUfoShip()
		self.addShot()
		self.loaBackgroundSounds()
	}

	private func addPointsCounter() {
		let pointsText = NSString(format: "%03d", hitsLabelPoints)

		pointsCounter.fontName = "Apple Color Emoji"
		pointsCounter.text = "\(hitsLabelText) \(pointsText)"
		pointsCounter.fontSize = 36
		pointsCounter.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
		pointsCounter.position = CGPoint(x: Int(CGRectGetMaxX(self.frame)) - (separator * 3), y: Int(CGRectGetMaxY(self.frame)) - separator - 5)

		self.addChild(pointsCounter)
		//myLabel.runAction(SKAction.sequence([SKAction.waitForDuration(3.0), SKAction.fadeOutWithDuration(1), SKAction.removeFromParent()]))
	}

	private func addMenuBack() {
		let menuBack = SKLabelNode()

		menuBack.fontName = "Apple Color Emoji"
		menuBack.text = "Menu"
		menuBack.name = menuBackName
		menuBack.fontSize = 36
		menuBack.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
		menuBack.position = CGPoint(x: Int(CGRectGetMidX(self.frame)) - (separator / 2), y: Int(CGRectGetMaxY(self.frame)) - separator - 5)

		self.addChild(menuBack)
	}

	private func addUserLifes(){
		for userLifeItem in 1...userLifesMaxCount {
			addUserLifeImage(userLifeItem)
		}
	}

	private func addUserLifeImage(userLifeItem: Int){
		let location = CGPoint(x: separator * userLifeItem, y: Int(CGRectGetMaxY(self.frame)) - separator)
		let userLifeShip = SKSpriteNode(imageNamed:"UserShip")

		userLifeShip.xScale = userShipScale / 2
		userLifeShip.yScale = userShipScale / 2
		userLifeShip.position = location
		userLifeShip.zPosition = 1000

		userLifeShips.append(userLifeShip)
		self.addChild(userLifeShip)
	}

	private func loaBackgroundSounds() {
		//		let backgroundMusic = SKAudioNode(fileNamed: "engine.wav")
		//		backgroundMusic.autoplayLooped = true
		//		addChild(backgroundMusic)
	}

	private func loadExplosions() {
		for imageFrame in 0...169 {
			let indexImage:String = String(format: "%03d", imageFrame)
			let imagePath: String = "explosion0\( indexImage )"
			let image: SKTexture = SKTexture(imageNamed: imagePath)

			enemyExplosionImages.append(image)
		}

		for imageFrame in 0...307 {
			let indexImage:String = String(format: "%03d", imageFrame)
			let imagePath: String = "ufoexplosion0\( indexImage )"
			let image: SKTexture = SKTexture(imageNamed: imagePath)

			ufoExplosionImages.append(image)
		}

		for imageFrame in 0...281 {
			let indexImage:String = String(format: "%03d", imageFrame)
			let imagePath: String = "shipexplosion0\( indexImage )"
			let image: SKTexture = SKTexture(imageNamed: imagePath)

			shipExplosionImages.append(image)
		}
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
					didMenu()
				}
			}

			let duration: Double = abs(Double((userSpaceShip.position.x - location.x) / (CGRectGetWidth(self.frame) * 2)))

			if(userSpaceShip.position.x - location.x > 0) {
				userSpaceShip.texture = userSpaceShipToLeft
			} else {
				userSpaceShip.texture = userSpaceShipToRight
			}

			let action = SKAction.moveToX(location.x, duration: duration)

			userSpaceShip.runAction(action, completion: {() -> Void in
				self.userSpaceShip.texture = self.userSpaceShipQuiet
			})
		}
	}

	private func didMenu() {
		if let scene = GameStartScene(fileNamed:"GameStartScene") {
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

				if ((firstBody!.categoryBitMask & PhysicsCategory.UserShip != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.UFO != 0)) {
					ufoDidCollideWithShip(enemyObject)
				}
				else if ((firstBody!.categoryBitMask & PhysicsCategory.UserShip != 0) &&
					(secondBody!.categoryBitMask & PhysicsCategory.Enemy != 0)) {
					enemyDidCollideWithShip(enemyObject)
				}
				else
					if(isShotEnabled) {
						if ((firstBody!.categoryBitMask & PhysicsCategory.Shot != 0) &&
							(secondBody!.categoryBitMask & PhysicsCategory.Enemy != 0)) {
							try projectileDidCollideWithEnemy(userObject, enemy: enemyObject)
						}
						else if ((firstBody!.categoryBitMask & PhysicsCategory.Shot != 0) &&
							(secondBody!.categoryBitMask & PhysicsCategory.UFO != 0)) {
							projectileDidCollideWithUFO(userObject, ufo: enemyObject)
						}
				}
				/*
				else if ((firstBody!.categoryBitMask & PhysicsCategory.UserShip != 0) &&
				(secondBody!.categoryBitMask & PhysicsCategory.EnemyShot != 0)) {
				try ufoDidCollideWithShip(userObject, ufo: enemyObject)
				}*/

			}
		}
		catch let error as NSError {
			print("Unexpected ERROR \( error.description )")
		}
	}

	private func enemyDidCollideWithShip(enemy: SKSpriteNode) {
		doShipExplotion()
		playExplotionSound()
	}

	private func playExplotionSound() {
		runAction(SKAction.sequence([SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: true)]))
	}

	private func ufoDidCollideWithShip(ufo: SKSpriteNode) {
		doShipExplotion()
		playExplotionSound()
	}

	private func doShipExplotion() {
		isShotEnabled = false
		let path = NSBundle.mainBundle().pathForResource("ShipExplotionParticle", ofType: "sks")
		let shipExplotionParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode

		shipExplotionParticle.position = userSpaceShip.position
		shipExplotionParticle.name = "shipExplotionParticle"
		shipExplotionParticle.targetNode = self.scene
		shipExplotionParticle.zPosition = 1000

		let hiddenShipAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(shipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			self.userSpaceShip.position = CGPoint(x: -CGRectGetMaxX(self.frame), y: -CGRectGetMaxY(self.frame))
		})
		let showShipAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(shipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.shipExplosionTime) && elapsedTime > CGFloat(self.shottingSpeed) * 2) {
				self.userSpaceShip.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.yUserShipPosition)
				self.isShotEnabled = true
				self.addShot();
			}
		})
		self.addChild(shipExplotionParticle)
		self.removeUserLife()

		shipExplotionParticle.runAction(SKAction.sequence([hiddenShipAction, SKAction.waitForDuration(1), showShipAction, SKAction.removeFromParent()]))
	}

	private func removeUserLife() {
		userLifesCounter -= 1

		if(userLifesCounter >= 0) {
			userLifeShips[userLifesCounter].runAction(SKAction.fadeOutWithDuration(1))
		}
		else {
			didLose()
		}
	}

	private func didLose() {
		if let scene = GameLostScene(fileNamed:"GameLostScene") {
			let transition = SKTransition.fadeWithDuration(2)
			self.view?.presentScene(scene, transition: transition)
		}
	}

	private func projectileDidCollideWithUFO(shot: SKSpriteNode, ufo: SKSpriteNode) {
		//NO FUNCA !!! dispatch_semaphore_wait(ufoSemaphore, DISPATCH_TIME_FOREVER)

		disposeShot(shot)
		doUfoExplosion(ufo)
		playExplotionSound()

		//dispatch_semaphore_signal(ufoSemaphore)
	}

	private func doUfoExplosion(ufo: SKSpriteNode) {
		ufo.removeAllActions()
		ufo.hidden = false
		ufo.physicsBody = nil
		let position:CGPoint = ufo.position
		ufo.position = CGPoint(x: -CGRectGetMidX(self.frame), y: -CGRectGetMaxY(self.frame))
		ufo.removeFromParent()


		let fakeUfoShip: SKSpriteNode = SKSpriteNode(imageNamed:"UFOShip")
		fakeUfoShip.xScale = ufoShipScale
		fakeUfoShip.yScale = ufoShipScale
		fakeUfoShip.position = position
		fakeUfoShip.zPosition = 1000
		self.addChild(fakeUfoShip)

		fakeUfoShip.runAction(SKAction.fadeOutWithDuration(0.35), completion: {() -> Void in
			fakeUfoShip.hidden = true
			fakeUfoShip.removeFromParent()
		})

		let ufoExplotion: SKSpriteNode = SKSpriteNode()
		ufoExplotion.texture = ufoExplosionImages[0]
		ufoExplotion.position = position
		ufoExplotion.size.height = ufo.size.height * 3
		ufoExplotion.size.width = ufo.size.height * 3
		ufoExplotion.zPosition = 900
		self.addChild(ufoExplotion)

		let animateExplosion = SKAction.animateWithTextures(ufoExplosionImages, timePerFrame: timePerFrameAnimation)
		ufoExplotion.runAction(animateExplosion, completion:  {() -> Void in
			ufoExplotion.removeFromParent()
			self.addUfoShip()
		})

		ufoHitted()
	}

	private func ufoHitted() {
		self.addPointsToHits(3)
		self.didWon()
	}

	private func addPointsToHits(points:Int) {
		hitsLabelPoints += points
		let pointsText = NSString(format: "%03d", hitsLabelPoints)

		pointsCounter.text = "\(hitsLabelText) \(pointsText)"
	}

	private func didWon() {
		if(hitsLabelPoints >= 100) {
			if let scene = GameWonScene(fileNamed:"GameWonScene") {
				let transition = SKTransition.fadeWithDuration(2)
				self.view?.presentScene(scene, transition: transition)
			}
		}
	}

	private func projectileDidCollideWithEnemy(shot: SKSpriteNode, enemy: SKSpriteNode) throws {
		disposeShot(shot)
		doEnemyExplosion(enemy)
		playExplotionSound()
	}

	private func disposeShot(shot: SKSpriteNode) {
		shot.hidden = true
		shot.position.x = CGRectGetMidX(self.frame) - CGRectGetMaxX(self.frame)
	}

	private func doEnemyExplosion(enemy: SKSpriteNode) {
		enemy.removeActionForKey(enemyShipRunActionKey)
		enemy.hidden = false
		enemy.physicsBody = nil
		let position:CGPoint = enemy.position
		enemy.position = CGPoint(x: -CGRectGetMidX(self.frame), y: -CGRectGetMidY(self.frame))
		enemy.removeFromParent()

		let falseEnemyShip: SKSpriteNode = SKSpriteNode(imageNamed:"EnemyShip")
		falseEnemyShip.xScale = enemyShipScale
		falseEnemyShip.yScale = enemyShipScale
		falseEnemyShip.position = position
		falseEnemyShip.zPosition = 900
		self.addChild(falseEnemyShip)

		falseEnemyShip.runAction(SKAction.fadeOutWithDuration(0.35), completion: {() -> Void in
			falseEnemyShip.removeFromParent()
		})

		let animateExplosion = SKAction.animateWithTextures(enemyExplosionImages, timePerFrame: timePerFrameAnimation)
		let enemyExplotion: SKSpriteNode = SKSpriteNode()
		enemyExplotion.texture = enemyExplosionImages[0]
		enemyExplotion.position = position
		enemyExplotion.size.height = enemy.size.height * 5
		enemyExplotion.size.width = enemy.size.height * 5
		enemyExplotion.zPosition = 800

		self.addChild(enemyExplotion)
		enemyExplotion.runAction(animateExplosion, completion:  {() -> Void in
			enemyExplotion.removeFromParent()
			self.addEnemyShip()
		})

		enemyHitted()
	}

	private func enemyHitted() {
		self.addPointsToHits(1)
		self.didWon()
	}

	private func addSpaceShip() {
		let location = CGPoint(x: CGRectGetMidX(self.frame), y: self.yUserShipPosition)
		userSpaceShip = SKSpriteNode(imageNamed:"UserShip")

		userSpaceShip.xScale = userShipScale
		userSpaceShip.yScale = userShipScale
		userSpaceShip.position = location
		userSpaceShip.zPosition = 500

		userSpaceShip.physicsBody = SKPhysicsBody(circleOfRadius: userSpaceShip.size.width / 2)
		userSpaceShip.physicsBody?.dynamic = true
		userSpaceShip.physicsBody?.categoryBitMask = PhysicsCategory.UserShip
		userSpaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy + PhysicsCategory.UFO
		userSpaceShip.physicsBody?.collisionBitMask = PhysicsCategory.None
		userSpaceShip.physicsBody?.usesPreciseCollisionDetection = true

		self.addChild(userSpaceShip)
	}

	private func addShot() {
		let location = CGPoint(x: userSpaceShip.position.x, y: userSpaceShip.position.y + (userSpaceShip.size.height / 2) )
		let shot = SKSpriteNode(imageNamed: "Shot")

		shot.xScale = shotScale
		shot.yScale = shotScale
		shot.position = location
		shot.zPosition = -500

		shot.physicsBody = SKPhysicsBody(rectangleOfSize: shot.size)
		shot.physicsBody?.dynamic = true
		shot.physicsBody?.categoryBitMask = PhysicsCategory.Shot
		shot.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
		shot.physicsBody?.collisionBitMask = PhysicsCategory.None
		shot.physicsBody?.usesPreciseCollisionDetection = true

		let moveAction:SKAction = SKAction.moveToY(CGRectGetMaxY(self.frame), duration: 1)
		let anotherShotAction:SKAction = SKAction.customActionWithDuration(shottingSpeed, actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.shottingSpeed)) {
				self.addShot()
			}
		})

		self.addChild(shot)

		shot.runAction(SKAction.sequence([SKAction.playSoundFileNamed("shot.wav",waitForCompletion:false), moveAction, SKAction.removeFromParent()]))

		if(isShotEnabled) {
			self.runAction(SKAction.sequence([ SKAction.waitForDuration(shottingSpeed), anotherShotAction]))
		}
	}

	private func addUfoShip() {
		let yPosition: CGFloat = random(min: CGRectGetMidY(self.frame) - 50, max: CGRectGetMaxY(self.frame) + 150)
		let location = CGPoint(x: CGRectGetMinX(self.frame) - 50, y: yPosition)
		let ufoShip: SKSpriteNode = SKSpriteNode(imageNamed:"UFOShip")

		ufoShip.xScale = ufoShipScale
		ufoShip.yScale = ufoShipScale
		ufoShip.position = location
		ufoShip.zPosition = 100

		ufoShip.physicsBody = SKPhysicsBody(circleOfRadius: ufoShip.size.width / 2)
		ufoShip.physicsBody?.dynamic = true
		ufoShip.physicsBody?.categoryBitMask = PhysicsCategory.UFO
		ufoShip.physicsBody?.contactTestBitMask = PhysicsCategory.Shot
		ufoShip.physicsBody?.collisionBitMask = PhysicsCategory.None
		ufoShip.physicsBody?.usesPreciseCollisionDetection = false

		self.addChild(ufoShip)

		let rotateAction = SKAction.rotateByAngle(CGFloat(M_2_PI), duration: NSTimeInterval(ufoAngularSpeed))
		ufoShip.runAction(SKAction.repeatActionForever(rotateAction))

		let anotherUfoAction:SKAction = getAddUfoShipAction()
		let path:UIBezierPath = UIBezierPath(arcCenter: CGPointMake(location.x, -yPosition), radius: yPosition, startAngle: CGFloat(M_PI_2), endAngle: -CGFloat(M_PI_4 / 2), clockwise: false)
		let moveAction = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: true, duration: 5.0)
		ufoShip.runAction(SKAction.sequence([SKAction.waitForDuration(1), moveAction, anotherUfoAction, SKAction.removeFromParent()]))
	}

	private func getAddUfoShipAction() -> SKAction {
		let anotherUfoAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(showUfoSpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.showUfoSpeed)) {
				self.addUfoShip()
			}
		})

		return anotherUfoAction
	}

	private func addEnemyShip() {
		let xPosition: CGFloat = random(min: CGRectGetMinX(self.frame) + 22, max: CGRectGetMaxX(self.frame) - 22)
		let location = CGPoint(x: xPosition, y: CGRectGetMaxY(self.frame) + 50)
		let enemyShip: SKSpriteNode = SKSpriteNode(imageNamed:"EnemyShip")
		let toYDestination = CGRectGetMinY(self.frame) - CGRectGetMidY(self.frame) / 3;

		enemyShip.xScale = enemyShipScale
		enemyShip.yScale = enemyShipScale
		enemyShip.position = location
		enemyShip.zPosition = 0

		enemyShip.physicsBody = SKPhysicsBody(circleOfRadius: enemyShip.size.width / 2)
		enemyShip.physicsBody?.dynamic = true
		enemyShip.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
		enemyShip.physicsBody?.contactTestBitMask = PhysicsCategory.Shot
		enemyShip.physicsBody?.collisionBitMask = PhysicsCategory.None
		enemyShip.physicsBody?.usesPreciseCollisionDetection = false

		self.addChild(enemyShip)

		let anotherEnemyAction:SKAction = getAddEnemyShipAction()
		let moveAction = SKAction.moveToY(toYDestination, duration: NSTimeInterval(enemySpeed))

		enemyShip.runAction(SKAction.sequence([SKAction.waitForDuration(1), moveAction, anotherEnemyAction, SKAction.removeFromParent()]),
		                    withKey: enemyShipRunActionKey)
	}

	private func getAddEnemyShipAction() -> SKAction {
		let anotherEnemyAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(showEnemySpeed), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.showEnemySpeed)) {
				self.addEnemyShip()
			}
		})

		return anotherEnemyAction
	}

	private func random() -> CGFloat {
		return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
	}
	
	private func random(min min: CGFloat, max: CGFloat) -> CGFloat {
		return random() * (max - min) + min
	}
}
