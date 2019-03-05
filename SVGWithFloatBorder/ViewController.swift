//
//  ViewController.swift
//  SVGWithFloatBorder
//
//  Created by Andrew Romanov on 05/03/2019.
//  Copyright © 2019 Andrew Romanov. All rights reserved.
//

import UIKit
import Macaw
import ImageIO
import CoreImage


extension UIImage {
	func getPixelColor(pos: CGPoint) -> UIColor {
		
		guard let coreImage = self.cgImage else {
			return UIColor.clear
		}
		
		guard let dataProvider = coreImage.dataProvider else {
			return UIColor.clear
		}
		guard let pixelData = dataProvider.data else{
			return UIColor.clear
		}
		let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
		
		let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
		
		let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
		let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
		let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
		let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
		
		return UIColor(red: r, green: g, blue: b, alpha: a)
	}
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		guard let svg = try? SVGParser.parse(resource: "h") else {
			assert(false)
			return
		}
		
		guard let bounds = svg.bounds  else {
			assert(false)
			return
		}
		
		let maxDimention = 828.0
		let maxSVGDimention = max(bounds.w, bounds.h)
		let scale = maxDimention / maxSVGDimention
		let size = CGSize(width: ceil(bounds.w * scale), height: ceil(bounds.h * scale))
		
		
		let image : UIImage = svg.toNativeImage(size: size.toMacaw(), layout: ContentLayout.of(contentMode: .scaleToFill))
		guard let coreImage = image.cgImage else {
			return
		}
			
		for i in 0..<coreImage.width {
			for j in 0..<coreImage.height {
				let pos = CGPoint(x: i, y: j)
				let color = image.getPixelColor(pos: pos)
				let ciColor = CIColor(color: color)
				let alpha = ciColor.alpha
				assert(alpha == 1.0)
			}
		}
		
		self.imageView.image = image;
		
	}
	
	
	@IBOutlet var imageView : UIImageView!


}

