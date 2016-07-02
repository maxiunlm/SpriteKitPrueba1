//
//  GameLostScene.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 13/6/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//


import Foundation
import SpriteKit

class GameLostScene: SKScene {
	override func didMoveToView(view: SKView) {
		steBackgroundImage()
		loaBackgroundSounds()
	}

	private func steBackgroundImage() {
		let spaceBackground = SKSpriteNode(imageNamed:"lost")

		spaceBackground.zPosition = -1000
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