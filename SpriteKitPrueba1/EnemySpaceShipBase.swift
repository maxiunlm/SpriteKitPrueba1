import Foundation
import SpriteKit


public class EnemySpaceShipBase: SpaceShipBase{
	internal var spaceShipExplosionImages: [SKTexture] = []
	internal var explotionFileName: String?
	internal var maxExplotionImageIndex: Int?
	
	public override init(gameScene: SKScene) {
		super.init(gameScene: gameScene)	}
	
	internal func loadExplosions() {
		var imageFrameIndex = 0
		
		//for imageFrame in 0...maxExplotionImageIndex {
		while (imageFrameIndex < maxExplotionImageIndex) {
			let indexImage:String = String(format: "%03d", imageFrameIndex)
			let imagePath: String = "\(explotionFileName)0\( indexImage )"
			let image: SKTexture = SKTexture(imageNamed: imagePath)
			
			self.spaceShipExplosionImages.append(image)
			imageFrameIndex += 1
		}
	}
	
	internal override func addSpaceShip() {
	}
}