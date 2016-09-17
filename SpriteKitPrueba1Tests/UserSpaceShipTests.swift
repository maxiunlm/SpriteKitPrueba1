//
//  UserShipTests.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 10/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import XCTest
import SpriteKit

@testable import SpriteKitPrueba1

class UserSpaceShipInternalMock: SKSpriteNode {
	internal var runActionMockHasBeenCalled: Bool = false
	
	override func run(_ action: SKAction, completion block: @escaping () -> Void){
		self.runActionMockHasBeenCalled = true;
	}
}


class UserSpaceShipTests: XCTestCase {
	fileprivate var sut: UserSpaceShip = UserSpaceShip(frame: CGRect())
	
	/// FIXTURE {
	
	fileprivate let frame = CGRect()
	fileprivate let userSpaceShipInternalMock = UserSpaceShipInternalMock()
	
	/// } FIXTURE
	
	
	override func setUp() {
		super.setUp()
		
		sut = UserSpaceShip(gameScene: self.frame)
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func test_init_withFrame_SetsItToItsInternalFrameProperty() {
		
		sut = UserSpaceShip(gameScene: self.frame)
		
		XCTAssertEqual(self.gameScene, sut.gameScene)
	}
	
	func test_init_withoutParameters_InvokesRunActionMethod() {
		sut.userSpaceShip = userSpaceShipInternalMock
		
		sut.runAction(SKAction(), completion: {() -> Void in
		})
		
		XCTAssertTrue(userSpaceShipInternalMock.runActionMockHasBeenCalled)
	}
	
	func testPerformanceExample() {
		self.measure {
		}
	}
	
}
