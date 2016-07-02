//
//  GameStartScene.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 29/5/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit

class GameStartScene: SKScene {
	private let separator = 50
	private let exitName = "Exit"

	override func didMoveToView(view: SKView) {
		setBackgroundImage()
		loaBackgroundSounds()
		addExit()
	}

	private func addExit() {
		let exitAction = SKLabelNode()

		exitAction.fontName = "Apple Color Emoji"
		exitAction.text = "\(exitName)"// \(self.size.width)x\(self.size.height)"


		exitAction.name = exitName
		exitAction.fontSize = 36
		exitAction.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
		exitAction.position = CGPoint(x: Int(CGRectGetMidX(self.frame)) - (separator / 2), y: Int(CGRectGetMaxY(self.frame)) - separator - 100)

		self.addChild(exitAction)
	}


	private func setBackgroundImage() {
		let spaceBackground = SKSpriteNode(imageNamed:"menu")
		//let screenSize: CGRect = UIScreen.mainScreen().bounds;

		spaceBackground.zPosition = -1000
		//spaceBackground.size = CGSizeMake(screenSize.width, screenSize.height)
		spaceBackground.size = CGSizeMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame))
		spaceBackground.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))

		backgroundColor = SKColor.blackColor()
		addChild(spaceBackground)
	}

	private func loaBackgroundSounds() {
		let backgroundMusic = SKAudioNode(fileNamed: "engine.wav")
		backgroundMusic.autoplayLooped = true
		addChild(backgroundMusic)
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			let location = touch.locationInNode(self)

			if let elementName = self.nodeAtPoint(location).name {
				if elementName == exitName {
					exit(0)
				}
			}
		}
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let scene = GameScene(fileNamed:"GameScene") {
			scene.size = self.size
			scene.scaleMode = .AspectFill

			self.removeAllActions()
			self.removeAllChildren()
			let transition = SKTransition.fadeWithDuration(1)

			self.view?.presentScene(scene, transition: transition)
		}
	}
}