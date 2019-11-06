//
//  CircleProgressView.swift
//  apc
//
//  Created by uke on 2019/1/4.
//  Copyright © 2019 uke. All rights reserved.
//

import Foundation

public class CircleProgressView: UIView {
    
    @IBInspectable public var progressWidth: CGFloat = 5
    @IBInspectable public var trackColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    @IBInspectable public var progressColor: UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    lazy var path: UIBezierPath = {
       return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: bounds.width / 2 - progressWidth, startAngle: -0.5 * CGFloat.pi, endAngle: CGFloat.pi * 1.5, clockwise: true)
    }()
    
    public var progress: CGFloat = 1 {
        didSet {
            guard progress >= 0 || progress <= 1 else {return}
            setProgress(progress, animated: true, withDuration: 0.3)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        // 绘制圆
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
//                    radius: bounds.width / 2 - progressWidth,
//                    startAngle: -0.5 * CGFloat.pi,
//                    endAngle: CGFloat.pi * 1.5,
//                    clockwise: true)
        // 绘制进度槽
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = progressWidth
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        // 绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = progressWidth
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        layer.addSublayer(progressLayer)
    }
    
    public func setProgress(_ progress: CGFloat, animated animate: Bool, withDuration duration: TimeInterval) {
//        print(progress)
        CATransaction.begin()
        CATransaction.setDisableActions(!animate)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = progress
        CATransaction.commit()
    }
    
}
