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
	override func didMoveToView(view: SKView) {
		steBackgroundImage()
		loaBackgroundSounds()
	}

	private func steBackgroundImage() {
		let spaceBackground = SKSpriteNode(imageNamed:"menu")
		let screenSize: CGRect = UIScreen.mainScreen().bounds;

		spaceBackground.zPosition = -1000
		spaceBackground.size = CGSizeMake(screenSize.width, screenSize.height)
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
			let transition = SKTransition.fadeWithDuration(2)
			self.view?.presentScene(scene, transition: transition)
		}
	}
}