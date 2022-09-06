//
//  CloudView.swift
//  VKApp
//
//  Created by Artem Mayer on 24.04.2022.
//

import UIKit

//MARK: - UIView
final class CloudView: UIView {
    private lazy var path: UIBezierPath = {
        return UIBezierPath()
    }()

    private lazy var shape: CAShapeLayer = {
        return CAShapeLayer()
    }()

    private lazy var animationCloudLayer = {
        return CAShapeLayer()
    }()

    private lazy var animationGroup = {
        return CAAnimationGroup()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCloudViewFrame(frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupCloudViewFrame(self.frame)
    }

    deinit {
        self.animationCloudLayer.removeAllAnimations()
    }

    // MARK: - setupCloudViewFrame
    private func setupCloudViewFrame(_ frame: CGRect) {
        self.alpha = 0
        self.isHidden = true
        self.widthAnchor.constraint(equalToConstant: 160).isActive = true
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true

        drawPath()

        self.layer.addSublayer(self.shape)

        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 0
        strokeEnd.toValue = 1
        strokeEnd.duration = 2

        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.beginTime = 0.5
        strokeStart.fromValue = 0
        strokeStart.toValue = 1
        strokeStart.duration = 2

        animationGroup.duration = 2.5
        animationGroup.fillMode = .backwards
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        animationGroup.animations = [strokeStart, strokeEnd]
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
    }

    // MARK: - drawPath
    private func drawPath() {
        // Draw path from start point
        let startPoint = CGPoint(x: 38, y: 91)

        path.lineWidth = 7
        path.lineCapStyle = .round

        path.move(to: startPoint)
        path.addCurve(to: CGPoint(x: 38, y: 42.5),
                      controlPoint1: CGPoint(x: 4, y: 91.8),
                      controlPoint2: CGPoint(x: 1.1, y: 43.5))

        path.addCurve(to: CGPoint(x: 110, y: 33),
                      controlPoint1: CGPoint(x: 43, y: 5.1),
                      controlPoint2: CGPoint(x: 95, y: 1.7))

        path.addCurve(to: CGPoint(x: 134, y: 52.5),
                      controlPoint1: CGPoint(x: 122.3, y: 25.94),
                      controlPoint2: CGPoint(x: 138.84, y: 36.13))

        path.addCurve(to: CGPoint(x: 134, y: 91),
                      controlPoint1: CGPoint(x: 148.75, y: 56.4),
                      controlPoint2: CGPoint(x: 158, y: 78.64))

        path.close()

        // Create a shape based on a path
        shape.path = path.cgPath
        shape.lineWidth = 7
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.systemGray.cgColor
        shape.lineCap = .round

        // Create animation laye based on a path
        animationCloudLayer.path = path.cgPath
        animationCloudLayer.strokeColor = UIColor.systemBlue.cgColor
        animationCloudLayer.lineWidth = 7
        animationCloudLayer.fillColor = UIColor.clear.cgColor
        animationCloudLayer.lineCap = .round
        animationCloudLayer.cornerRadius = 10
    }

    // MARK: - startAnimation
    func startAnimation() {
        animationCloudLayer.add(animationGroup, forKey: nil)

        self.shape.addSublayer(self.animationCloudLayer)
        self.isHidden = false
    }

    // MARK: - removeAnimation
    func removeAnimation() {
        self.isHidden = true
        self.animationCloudLayer.removeAllAnimations()
    }
}
