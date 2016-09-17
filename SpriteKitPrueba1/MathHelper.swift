//
//  MathHelper.swift
//  SpriteKitPrueba1
//
//  Created by Maximiliano on 22/7/16.
//  Copyright © 2016 Maximiliano. All rights reserved.
//

import Foundation
import SpriteKit

//import Darwin


open class MathHelper {


	open static func random() -> CGFloat {
		return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
	}

	open static func random(min: CGFloat, max: CGFloat) -> CGFloat {
		return random() * (max - min) + min
	}
}
