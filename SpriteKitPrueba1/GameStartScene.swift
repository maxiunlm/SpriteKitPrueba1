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
	fileprivate let separator = 50
	fileprivate let exitName = "Exit"

	override func didMove(to view: SKView) {
		setBackgroundImage()
		loaBackgroundSounds()
		addExit()
	}

	fileprivate func addExit() {
		let exitAction = SKLabelNode()

		exitAction.fontName = "Apple Color Emoji"
		exitAction.text = "\(exitName)"// \(self.size.width)x\(self.size.height)"


		exitAction.name = exitName
		exitAction.fontSize = 22
		exitAction.verticalAlignmentMode = SKLabelVerticalAlignmentMode.bottom
		exitAction.position = CGPoint(x: Int(self.frame.midX) - (separator / 6), y: Int(self.frame.height) - (separator / 2))

		self.addChild(exitAction)
	}


	fileprivate func setBackgroundImage() {
		let spaceBackground = SKSpriteNode(imageNamed:"menu")
		//let screenSize: CGRect = UIScreen.mainScreen().bounds;

		spaceBackground.zPosition = -1000
		spaceBackground.size = CGSize(width: self.frame.width, height: self.frame.height)
		spaceBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

		backgroundColor = SKColor.black
		addChild(spaceBackground)
	}

	fileprivate func loaBackgroundSounds() {
		let backgroundMusic = SKAudioNode(fileNamed: "engine.wav")
		backgroundMusic.autoplayLooped = true
		addChild(backgroundMusic)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			let location = touch.location(in: self)

			if let elementName = self.atPoint(location).name {
				if elementName == exitName {
					exit(0)
				}
			}
		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let scene = GameScene(fileNamed:"GameScene") {
			scene.size = self.size
			scene.scaleMode = .aspectFill

			self.removeAllActions()
			self.removeAllChildren()
			let transition = SKTransition.fade(withDuration: 1)

			self.view?.presentScene(scene, transition: transition)
		}
	}
}
