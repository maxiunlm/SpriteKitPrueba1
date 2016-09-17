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
	override func didMove(to view: SKView) {
		steBackgroundImage()
		loaBackgroundSounds()
	}

	fileprivate func steBackgroundImage() {
		let spaceBackground = SKSpriteNode(imageNamed:"lost")

		spaceBackground.zPosition = -1000
		spaceBackground.size = CGSize(width: self.frame.maxX, height: self.frame.maxY)
		spaceBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

		backgroundColor = SKColor.black
		addChild(spaceBackground)
	}

	fileprivate func loaBackgroundSounds() {
		let backgroundMusic = SKAudioNode(fileNamed: "engine.wav")
		backgroundMusic.autoplayLooped = true
		addChild(backgroundMusic)
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
