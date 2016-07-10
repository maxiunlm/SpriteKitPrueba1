//
//  File.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 10/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation


public enum PhysicsCategory: UInt32 {
	case None			= 0
	case UserShip		= 0b1				//  1
	case Shot			= 0b10			//  2
	case EnemyShot   	= 0b100			//  4
	case Enemy			= 0b1000			//  8
	case UFO				= 0b10000		// 16
	case All				= 0xFFFFFFFF
}