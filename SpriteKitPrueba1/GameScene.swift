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
		static let All			: UInt32 = UInt32.max
		static let UserShip		: UInt32 = 0b1			//  1
		static let Shot			: UInt32 = 0b10			//  2
		static let EnemyShot    : UInt32 = 0b100		//  4
		static let Enemy		: UInt32 = 0b1000		//  8
        static let UFO			: UInt32 = 0b10000		// 16
    }
    
    private var userSpaceShip: SKSpriteNode = SKSpriteNode()
    //private var enemyShip: SKSpriteNode = SKSpriteNode()
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
	private var shipExplosionTime: NSTimeInterval = NSTimeInterval(1)
	private var shipExplosionImages: [SKTexture] = []
	private let timePerFrameAnimation: NSTimeInterval = NSTimeInterval(0.025)
	
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        steBackgroundImage()
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Space warriors!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) * 1.55)
        
        self.addChild(myLabel)
        myLabel.runAction(SKAction.sequence([SKAction.waitForDuration(3.0), SKAction.fadeOutWithDuration(1), SKAction.removeFromParent()]))
		
		addSpaceShip()
        loadExplosions()
        addEnemyShip()
		addUfoShip()
        addShot()
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
    
    private func steBackgroundImage() {
        let spaceBackground = SKSpriteNode(imageNamed:"SpaceBackground")
        
        spaceBackground.zPosition = -1000
        spaceBackground.position = CGPoint (x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        spaceBackground.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
        
        backgroundColor = SKColor.blackColor()
        addChild(spaceBackground)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
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
   
    override func update(currentTime: CFTimeInterval) {
        //moveEnemy()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
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
		//doEnemyExplosion(enemy)
		doShipExplotion()
	}
	
	private func ufoDidCollideWithShip(ufo: SKSpriteNode) {
		//doUfoExplosion(ufo)
		doShipExplotion()
	}
	
	func doShipExplotion() {
		isShotEnabled = false
		let path = NSBundle.mainBundle().pathForResource("ShipExplotionParticle", ofType: "sks")
		let shipExplotionParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
		
		shipExplotionParticle.position = userSpaceShip.position
		shipExplotionParticle.name = "shipExplotionParticle"
		shipExplotionParticle.targetNode = self.scene
		shipExplotionParticle.zPosition = 1000

		let hiddenShipAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(shipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			self.userSpaceShip.position = CGPoint(x: -CGRectGetMaxX(self.frame), y: -CGRectGetMaxY(self.frame))
			//self.userSpaceShip.runAction(SKAction.fadeOutWithDuration(1));
		})
		let showShipAction:SKAction = SKAction.customActionWithDuration(NSTimeInterval(shipExplosionTime), actionBlock: { (node: SKNode!, elapsedTime: CGFloat) -> Void in
			if(elapsedTime >= CGFloat(self.shipExplosionTime) && elapsedTime > CGFloat(self.shottingSpeed) * 2) {
				self.userSpaceShip.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) / 2)
				//self.userSpaceShip.runAction(SKAction.fadeOutWithDuration(1));
				
				self.isShotEnabled = true
				self.addShot();
			}
		})
		self.addChild(shipExplotionParticle)
		
		shipExplotionParticle.runAction(SKAction.sequence([hiddenShipAction, SKAction.waitForDuration(1), showShipAction, SKAction.removeFromParent()]))
		//userSpaceShip.runAction(SKAction.fadeInWithDuration(1));
	}
	
	private func projectileDidCollideWithUFO(shot: SKSpriteNode, ufo: SKSpriteNode) {
		//NO FUNCA !!! dispatch_semaphore_wait(ufoSemaphore, DISPATCH_TIME_FOREVER)
		
		disposeShot(shot)
		doUfoExplosion(ufo)
		
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
			//self.addUfoShip()
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
	}
	
	private func projectileDidCollideWithEnemy(shot: SKSpriteNode, enemy: SKSpriteNode) throws {
		//NO FUNCA !!! dispatch_semaphore_wait(enemySemaphore, DISPATCH_TIME_FOREVER)
		disposeShot(shot)
		doEnemyExplosion(enemy)
		
		//dispatch_semaphore_signal(enemySemaphore)
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
			//self.addEnemyShip()
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
    }
	
    private func addSpaceShip() {
        let location = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) / 2)
        userSpaceShip = SKSpriteNode(imageNamed:"UserShip")
        
        userSpaceShip.xScale = userShipScale
        userSpaceShip.yScale = userShipScale
		userSpaceShip.position = location
		//userSpaceShip.hidden = true
		userSpaceShip.zPosition = 500
		
		userSpaceShip.physicsBody = SKPhysicsBody(circleOfRadius: userSpaceShip.size.width / 2)
		userSpaceShip.physicsBody?.dynamic = true
		userSpaceShip.physicsBody?.categoryBitMask = PhysicsCategory.UserShip
		userSpaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy + PhysicsCategory.UFO
		userSpaceShip.physicsBody?.collisionBitMask = PhysicsCategory.None
		userSpaceShip.physicsBody?.usesPreciseCollisionDetection = true
		
		self.addChild(userSpaceShip)
		//userSpaceShip.hidden = false
		//userSpaceShip.runAction(SKAction.sequence([SKAction.waitForDuration(1.0),SKAction.fadeInWithDuration(1)]))
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
		
		shot.runAction(SKAction.sequence([ moveAction, SKAction.removeFromParent()]))
		
		if(isShotEnabled) {
			self.runAction(SKAction.sequence([ SKAction.waitForDuration(shottingSpeed), anotherShotAction]))
		}
	}
	
	private func addUfoShip() {
		let yPosition: CGFloat = random(min: CGRectGetMidY(self.frame) - 50, max: CGRectGetMaxY(self.frame) + 150)
		let location = CGPoint(x: CGRectGetMinX(self.frame), y: yPosition)
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
		let path:UIBezierPath = UIBezierPath(arcCenter: CGPointMake(location.x, -yPosition), radius: yPosition, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(0), clockwise: false)
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
		let location = CGPoint(x: xPosition, y: CGRectGetMaxY(self.frame))
		let enemyShip: SKSpriteNode = SKSpriteNode(imageNamed:"EnemyShip")
		
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
		let moveAction = SKAction.moveToY(CGRectGetMinY(self.frame), duration: NSTimeInterval(enemySpeed))
		
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
