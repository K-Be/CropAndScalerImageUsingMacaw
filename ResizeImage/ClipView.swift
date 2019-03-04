//
//  ClipView.swift
//  ResizeImage
//
//  Created by Andrew Romanov on 04/03/2019.
//  Copyright © 2019 Andrew Romanov. All rights reserved.
//

import UIKit

public class ClipView: UIView, UIGestureRecognizerDelegate {
	
	private var corner1 = UIView(frame:CGRect(x: 0.0, y: 0.0, width: 15.0, height: 15.0))
	private var corner2 = UIView(frame:CGRect(x: 0.0, y: 0.0, width: 15.0, height: 15.0))
	
	private var panRecognizer = UIPanGestureRecognizer(target: nil, action: nil)
	private var activeCorner : UIView?
	
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.addUIElementes()
	}
	
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.addUIElementes()
	}
	
	
	
	private func addUIElementes() {
		let selfBounds = self.bounds
		
		self.addSubview(corner1)
		corner1.center = CGPoint(x: selfBounds.midX / 2.0, y: selfBounds.midY / 2.0);
		corner1.backgroundColor = UIColor.red
		
		self.addSubview(corner2)
		corner2.center = CGPoint(x: selfBounds.midX / 2.0 + selfBounds.midX, y: selfBounds.midY / 2.0 + selfBounds.midY);
		corner2.backgroundColor = UIColor.red
		
		self.addGestureRecognizer(panRecognizer)
		panRecognizer.addTarget(self, action: #selector(recognizerAction(_:)))
		panRecognizer.delegate = self
	}
	
	
	var clipRect : CGRect {
		get {
			
			let minPoint = CGPoint(x: min(corner1.center.x, corner2.center.x), y: min(corner1.center.y, corner2.center.y))
			let maxPoint = CGPoint(x: max(corner1.center.x, corner2.center.x), y: max(corner1.center.y, corner2.center.y))
			
			let rect = CGRect(x: minPoint.x, y: minPoint.y, width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y)
			
			return rect
		}
	}
	
	
	//MARK: UIGestureRecognizerDelegate
	override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
	{
		let position : CGPoint = gestureRecognizer.location(in: self)
		let can = self.viewForLocation(position) != nil
		return can
	}
	
	
	@objc func recognizerAction(_ sender: UIPanGestureRecognizer) {
		switch sender.state {
		case .began:
			self.activeCorner = self.viewForLocation(sender.location(in: self))
		case .changed:
			guard let active = self.activeCorner else {
				return
			}
			let center = sender.location(in: self)
			active.center = center
		case .ended, .cancelled, .failed:
			activeCorner = nil
		case .possible: break
			
		}
	}
	
	
	private func viewForLocation(_ location: CGPoint) -> UIView? {
		
		let views = [corner1, corner2]
		let result = views.first { (view) -> Bool in
			let frame = view.frame
			let match = frame.contains(location)
			return match
		}
		
		return result;
	}
	
}
