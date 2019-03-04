//
//  ViewController.swift
//  ResizeImage
//
//  Created by Andrew Romanov on 04/03/2019.
//  Copyright © 2019 Andrew Romanov. All rights reserved.
//

import UIKit
import Macaw

class ViewController: UIViewController {

	@IBOutlet var sourceImageView : UIImageView!
	@IBOutlet var resultImageView : UIImageView!
	
	@IBOutlet var clipView : ClipView!
	@IBOutlet var scaleSlider : UISlider!
	@IBOutlet var cropButton : UIButton!
	@IBOutlet var scaleValue : UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cropButton.addTarget(self, action: #selector(cropAction(_:)), for: .touchUpInside)
		
		scaleSlider.addTarget(self, action: #selector(scaleChanged(_:)), for: .valueChanged)
		scaleChanged(self.scaleSlider)
	}

	
	var scale : Float {
		get {
			return self.scaleSlider.value
		}
	}
	

	@objc func scaleChanged(_ sender: UISlider?) {
		scaleValue.text = "\(self.scale)"
	}
	
	
	@objc func cropAction(_ sender: UIButton?) {
		
		let scale : CGFloat  = CGFloat(self.scale)
		let clipFrame = self.sourceImageView.convert(self.clipView.clipRect, from: self.clipView)
		
		let imageNode = Image(image: self.sourceImageView.image ?? UIImage(named: "s1200.jpeg")!,
													w: Int(self.sourceImageView.bounds.width),
													h: Int(self.sourceImageView.bounds.height),
													clip: clipFrame.toMacaw())
		let groupNode = Group(contents: [imageNode],
													place: CGAffineTransform(scaleX: scale, y: scale).toMacaw())
		
		let resultImage = groupNode.toNativeImage(size: clipFrame.size.applying(CGAffineTransform(scaleX: scale, y: scale)).toMacaw())
		self.resultImageView.image = resultImage
	}
	
}

