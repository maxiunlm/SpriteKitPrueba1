//
//  File.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 10/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation


public enum PhysicsCategory: UInt32 {
	case none			= 0
	case userShip		= 0b1				//  1
	case shot			= 0b10			//  2
	case enemyShot   	= 0b100			//  4
	case enemy			= 0b1000			//  8
	case ufo				= 0b10000		// 16
	case all				= 0xFFFFFFFF
}
