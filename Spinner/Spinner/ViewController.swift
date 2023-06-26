import UIKit

class ViewController: UIViewController {
    
    private let arrow = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCircle(startAngle: 20, endAngle: 90)
        createArrow()
    }
    
    private func createSegment(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), radius: 150, startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: true)
    }
    
    private func createCircle(startAngle: CGFloat, endAngle: CGFloat) {
        let segmentPath = createSegment(startAngle: startAngle, endAngle: endAngle)
        let segmentLayer = CAShapeLayer()
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = 30
        segmentLayer.strokeColor = UIColor.blue.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        
        self.view.layer.addSublayer(segmentLayer)
    }
    
    private func createArrow() {
        arrow.bounds = CGRect(x: 0, y: 0, width: 10, height: 200)
        arrow.position = view.center
        arrow.backgroundColor = UIColor.red.cgColor
        
        // Устанавливаем точку вращения в центре слоя
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        view.layer.addSublayer(arrow)
        
        startSecondHandAnimation()
    }
    
    func startSecondHandAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 10 // Длительность анимации в секундах
        rotationAnimation.repeatCount = .infinity
        
        arrow.add(rotationAnimation, forKey: "secondHandAnimation")
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
