//
//  UserLife.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 30/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


open class UserLife {
	fileprivate let separator = 40
	fileprivate let userLifesMaxCount = 3
	fileprivate var userLifesCounter = 3
	fileprivate var userLifeShips:[SKSpriteNode] = []
	
	fileprivate var gameScene: SKScene
	fileprivate var userSpaceShip: UserSpaceShip
	
	
	public init(gameScene: SKScene, userSpaceShip: UserSpaceShip) {
		self.gameScene = gameScene
		self.userSpaceShip = userSpaceShip
	}
	
	open func addUserLifes(){
		for userLifeItem in 1...userLifesMaxCount {
			addUserLifeImage(userLifeItem)
		}
	}
	
	open func addUserLifeImage(_ userLifeItem: Int){
		let location = CGPoint(x: self.separator * userLifeItem, y: Int(self.gameScene.frame.height) - (self.separator / 2))
		let userLifeShip = SKSpriteNode(imageNamed:"UserLife")
		
		userLifeShip.xScale = self.userSpaceShip.spaceShipScale / 2.5
		userLifeShip.yScale = self.userSpaceShip.spaceShipScale / 2.5
		userLifeShip.position = location
		userLifeShip.zPosition = 1000
		
		self.userLifeShips.append(userLifeShip)
		self.gameScene.addChild(userLifeShip)
	}
	
	open func removeUserLife() -> Int {
		self.userLifesCounter -= 1
		
		if(self.userLifesCounter >= 0) {
			self.userLifeShips[self.userLifesCounter].run(SKAction.fadeOut(withDuration: 1))
		}
		
		return self.userLifesCounter
	}
}
