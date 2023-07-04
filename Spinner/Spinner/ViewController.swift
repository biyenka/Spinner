import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var livesCounter: UILabel!
    @IBOutlet weak var stage: UILabel!
    @IBOutlet weak var counter: UILabel!
    private var counterInt = 0
    private let arrow = CALayer()
    private let segmentLayer = CAShapeLayer()
    private var isIntersecting = true
    private var startAngle: CGFloat = Double.random(in: 0...360)
    private var lives = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabGestureInitialization()
        setTexts()
        firstStage()
    }
    
    private func firstStage() {
        stage.text = "Stage 1"
        view.backgroundColor = UIColor(hexFromString: "#fed001", alpha: 1.0)
        createCircle(startAngle: startAngle, endAngle: startAngle + 70)
        createArrow()
    }
    
    private func secondStage() {
        startArrowAnimation(speed: 2.5)
        createCircle(startAngle: startAngle, endAngle: startAngle + 70)
        stage.text = "Stage 2"
    }
    
    private func thirdStage() {
        startArrowAnimation(speed: 2)
        createCircle(startAngle: startAngle, endAngle: startAngle + 70)
        stage.text = "Stage 3"
    }
    
    private func setTexts() {
        counter.text = String(counterInt)
        livesCounter.text = String(lives)
    }

    private func tabGestureInitialization() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        _ = sender.location(in: self.view)
        
        guard let presentationLayer = arrow.presentation() else {
            return
        }
        
        let arrowFrame = presentationLayer.frame
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: arrowFrame.midX, y: arrowFrame.minY))
        arrowPath.addLine(to: CGPoint(x: arrowFrame.minX, y: arrowFrame.maxY))
        arrowPath.addLine(to: CGPoint(x: arrowFrame.maxX, y: arrowFrame.maxY))
        arrowPath.close()
        let segmentPath = UIBezierPath(cgPath: segmentLayer.path!)
        
        if arrowPath.cgPath.intersects(segmentPath.cgPath) {
            if isIntersecting {
                segmentLayer.removeFromSuperlayer()
                
                let startAngle: CGFloat = Double.random(in: 0...360)
                createCircle(startAngle: startAngle, endAngle: startAngle + 70)
                
                counterInt += 1
                counter.text = String(counterInt)
                
                switch counterInt {
                case 5: secondStage()
                case 10: thirdStage()
                default: break
                }
            }
        } else {
            lives -= 1
            livesCounter.text = String(lives)
            
            if lives == 0 {
                print("Конец игры")
            }
            
        }
    }
    
    private func createSegment(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), radius: Double.random(in: 80...150), startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: true)
    }
    
    private func createCircle(startAngle: CGFloat, endAngle: CGFloat) {
        let segmentPath = createSegment(startAngle: startAngle, endAngle: endAngle)
        
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.lineWidth = Double.random(in: 10...50)
        let color = UIColor(red: 76.0/255.0, green: 68.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        segmentLayer.strokeColor = color.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        segmentLayer.lineCap = .round
        
        view.layer.insertSublayer(segmentLayer, below: arrow)
    }
    
    private func createArrow() {
        arrow.bounds = CGRect(x: 0, y: 0, width: 5, height: 200)
        arrow.position = view.center
        arrow.backgroundColor = UIColor.white.cgColor
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        view.layer.addSublayer(arrow)
        
        startArrowAnimation(speed: 3)
    }
    
    private func startArrowAnimation(speed: Double) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = CFTimeInterval(speed)
        rotationAnimation.repeatCount = .infinity
        
        arrow.add(rotationAnimation, forKey: "secondHandAnimation")
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
