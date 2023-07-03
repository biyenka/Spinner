import UIKit

class ViewController: UIViewController {
    
    private let arrow = CALayer()
    private let segmentLayer = CAShapeLayer()
    private var isIntersecting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCircle(startAngle: 20, endAngle: 90)
        createArrow()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        _ = sender.location(in: self.view)
        
        guard let presentationLayer = arrow.presentation() else {
            return
        }
        
        let arrowPath = UIBezierPath(rect: presentationLayer.frame)
        let segmentPath = UIBezierPath(cgPath: segmentLayer.path!)
        
        if arrowPath.cgPath.intersects(segmentPath.cgPath) {
            if !isIntersecting {
                isIntersecting = true
                print("Попало!")
            }
        } else {
            isIntersecting = false
            print("Мимо")
        }
    }
    
    private func createSegment(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), radius: Double.random(in: 80...150), startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: true)
    }
    
    private func createCircle(startAngle: CGFloat, endAngle: CGFloat) {
        let segmentPath = createSegment(startAngle: startAngle, endAngle: endAngle)
        
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = 30
        segmentLayer.strokeColor = UIColor.blue.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        segmentLayer.lineCap = .round
        
        self.view.layer.addSublayer(segmentLayer)
    }
    
    private func createArrow() {
        arrow.bounds = CGRect(x: 0, y: 0, width: 7, height: 200)
        arrow.position = view.center
        arrow.backgroundColor = UIColor.red.cgColor
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        view.layer.addSublayer(arrow)
        
        startArrowAnimation()
    }
    
    private func startArrowAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 3
        rotationAnimation.repeatCount = .infinity
        
        arrow.add(rotationAnimation, forKey: "secondHandAnimation")
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
