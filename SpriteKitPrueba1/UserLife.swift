//
//  UserLife.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 30/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit


public class UserLife {
	private let separator = 50
	private let userLifesMaxCount = 3
	private var userLifesCounter = 3
	private var userLifeShips:[SKSpriteNode] = []
	
	private var gameScene: SKScene
	private var userSpaceShip: UserSpaceShip
	
	
	public init(gameScene: SKScene, userSpaceShip: UserSpaceShip) {
		self.gameScene = gameScene
		self.userSpaceShip = userSpaceShip
	}
	
	public func addUserLifes(){
		for userLifeItem in 1...userLifesMaxCount {
			addUserLifeImage(userLifeItem)
		}
	}
	
	public func addUserLifeImage(userLifeItem: Int){
		let location = CGPoint(x: self.separator * userLifeItem, y: Int(self.gameScene.frame.height) - (self.separator / 2))
		let userLifeShip = SKSpriteNode(imageNamed:"UserShip")
		
		userLifeShip.xScale = self.userSpaceShip.spaceShipScale / 1.5
		userLifeShip.yScale = self.userSpaceShip.spaceShipScale / 1.5
		userLifeShip.position = location
		userLifeShip.zPosition = 1000
		
		self.userLifeShips.append(userLifeShip)
		self.gameScene.addChild(userLifeShip)
	}
	
	public func removeUserLife() -> Int {
		self.userLifesCounter -= 1
		
		if(self.userLifesCounter >= 0) {
			self.userLifeShips[self.userLifesCounter].runAction(SKAction.fadeOutWithDuration(1))
		}
		
		return self.userLifesCounter
	}
}
