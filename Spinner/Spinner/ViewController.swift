import UIKit
import CoreGraphics
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet private weak var heart3: UIImageView!
    @IBOutlet private weak var heart2: UIImageView!
    @IBOutlet private weak var heart1: UIImageView!
    @IBOutlet private weak var stage: UILabel!
    @IBOutlet private weak var counter: UILabel!
    
    private var counterInt = 0
    private let arrow = CALayer()
    private let segmentStaticLayer = CAShapeLayer()
    private let segmentLayer = CAShapeLayer()
    private var isIntersecting = true
    private var startAngle: CGFloat = CGFloat.random(in: 0...360)
    private var lives = 3
    private var arrowRotationAnimation: CABasicAnimation?
    private var successSound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureInitialization()
        setTexts()
        setImages()
        firstStage()
      //  createAudio()
        
        createSpinnerSegment(color: .black, shouldAnimate: true)
    }
    
    private func createAudio() {
        if let soundURL = Bundle.main.url(forResource: "punch", withExtension: "mp3") {
            do {
                successSound = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print("Failed to load sound file: \(error)")
            }
        }
    }
    
    private func firstStage() {
        stage.text = "Stage 1"
        stage.textColor = UIColor(red: 41/255, green: 45/255, blue: 50/255, alpha: 1.0)
        counter.textColor = UIColor(red: 41/255, green: 45/255, blue: 50/255, alpha: 1.0)
        
        view.backgroundColor = UIColor(hexFromString: "#fed001", alpha: 1.0)
        createCircle(startAngle: startAngle, endAngle: startAngle + 70, color: UIColor(hexFromString: "#4c4480", alpha: 1.0))
        createArrow()
    }
    
    private func setImages() {
        heart1.image = UIImage(named: "heart1")
        heart2.image = UIImage(named: "heart1")
        heart3.image = UIImage(named: "heart1")
    }
    
    private func setTexts() {
        counter.text = String(counterInt)
    }
    
    // MARK: - ОБРАБОТКА НАЖАТИЯ НА СЕГМЕНТЫ
    private func tapGestureInitialization() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        guard let presentationLayer = arrow.presentation() else {
            return
        }
        let arrowFrame = presentationLayer.frame
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: arrowFrame.midX, y: arrowFrame.minY))
        arrowPath.addLine(to: CGPoint(x: arrowFrame.minX, y: arrowFrame.maxY))
        arrowPath.addLine(to: CGPoint(x: arrowFrame.maxX, y: arrowFrame.maxY))
        arrowPath.close()
        

        
        
//        guard let arrowPresentationLayer = arrow.presentation() else {
//            return
//        }
//        let arrowFrame = arrowPresentationLayer.frame
//
//        let arrowPath = UIBezierPath()
//        arrowPath.move(to: CGPoint(x: arrowFrame.midX, y: arrowFrame.minY))
//        arrowPath.addLine(to: CGPoint(x: arrowFrame.minX, y: arrowFrame.maxY))
//        arrowPath.addLine(to: CGPoint(x: arrowFrame.maxX, y: arrowFrame.maxY))
//        arrowPath.close()
//
//        // Обновление segmentMovingPath
//        if let segmentPath = segmentLayer.path {
//            let segmentMovingPath = UIBezierPath(cgPath: segmentPath)
//
//            // Выполнение проверки на пересечение
//            if arrowPath.cgPath.intersects(segmentMovingPath.cgPath) {
//                // Intersection occurred
//                print("Intersection detected!")
//            } else {
//                // No intersection occurred
//                print("No intersection detected.")
//            }
//        } else {
//            print("Segment layer or path not found.")
//        }
        
        
        
        let segmentStaticPath = UIBezierPath(cgPath: segmentStaticLayer.path!)
        if arrowPath.cgPath.intersects(segmentStaticPath.cgPath) {
            isIntersecting = true
            
            if isIntersecting {
                successSound?.play()
                segmentStaticLayer.removeFromSuperlayer()
                
                let startAngle: CGFloat = CGFloat.random(in: 0...360)
                
                counterInt += 1
                counter.text = String(counterInt)
                
                switch counterInt {
                case 0...4:
                    createCircle(startAngle: startAngle, endAngle: startAngle + 70, color: UIColor(hexFromString: "#4c4480", alpha: 1.0))
                case 5...9:
                    stage.text = "Stage 2"
                    createCircle(startAngle: startAngle, endAngle: startAngle + 70, color: UIColor(hexFromString: "#FF9642", alpha: 1.0))
                    startArrowAnimation(speed: 3)
                    view.backgroundColor = UIColor(hexFromString: "#02bbb5", alpha: 1.0)
                default: break
                }
            }
        } else {
            isIntersecting = false
            lives -= 1
            
            if lives == 2 {
                heart3.layer.opacity = 0.4
            } else if lives == 1 {
                heart2.layer.opacity = 0.4
            } else if lives == 0 {
                heart1.layer.opacity = 0.4
              //  print("Конец игры")
            }
        }
    }
    
    // MARK: - СТАТИЧНЫЙ СЕГМЕНТ
    private func createSegment(startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        return UIBezierPath(arcCenter: CGPoint(x: self.view.frame.midX, y: self.view.frame.midY), radius: CGFloat.random(in: 80...150), startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: true)
    }
    
    private func createCircle(startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        let segmentPath = createSegment(startAngle: startAngle, endAngle: endAngle)
        
        segmentStaticLayer.path = segmentPath.cgPath
        segmentStaticLayer.lineWidth = CGFloat.random(in: 10...30)
        segmentStaticLayer.strokeColor = color.cgColor
        segmentStaticLayer.fillColor = UIColor.clear.cgColor
        segmentStaticLayer.lineCap = .round
        
        view.layer.insertSublayer(segmentStaticLayer, below: arrow)
    }
    
    // MARK: - РАБОТА СО СТРЕЛКОЙ
    private func createArrow() {
        arrow.bounds = CGRect(x: 0, y: 0, width: 5, height: 200)
        arrow.position = view.center
        arrow.backgroundColor = UIColor.white.cgColor
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        view.layer.addSublayer(arrow)
        
        startArrowAnimation(speed: 3)
    }
    
    private func startArrowAnimation(speed: Double) {
        if let rotationAnimation = arrowRotationAnimation {
            let currentRotation = arrow.presentation()?.value(forKeyPath: "transform.rotation.z") as? Double ?? 0.0
            rotationAnimation.fromValue = currentRotation
            rotationAnimation.toValue = currentRotation + 2 * Double.pi
            rotationAnimation.duration = CFTimeInterval(speed)
            rotationAnimation.repeatCount = .infinity
            
            arrow.add(rotationAnimation, forKey: "secondHandAnimation")
            arrowRotationAnimation = rotationAnimation
        } else {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = 2 * Double.pi
            rotationAnimation.duration = CFTimeInterval(speed)
            rotationAnimation.repeatCount = .infinity
            
            arrow.add(rotationAnimation, forKey: "secondHandAnimation")
            arrowRotationAnimation = rotationAnimation
        }
    }
    
    // MARK: - ДВИГАЮЩИЙСЯ СЕГМЕНТ
    private func createSpinnerSegment(color: UIColor, shouldAnimate: Bool) {
        
        segmentLayer.lineWidth = 15.0
        segmentLayer.strokeColor = color.cgColor
        segmentLayer.fillColor = UIColor.clear.cgColor
        segmentLayer.lineCap = .round
        
        let segmentRadius: CGFloat = 150.0
        let segmentSize = CGSize(width: 2 * segmentRadius, height: 2 * segmentRadius)
        let segmentPath = UIBezierPath(arcCenter: CGPoint(x: segmentRadius, y: segmentRadius),
                                       radius: segmentRadius,
                                       startAngle: 0,
                                       endAngle: .pi * 0.8,
                                       clockwise: true)
        
        segmentLayer.path = segmentPath.cgPath
        segmentLayer.bounds = CGRect(origin: .zero, size: segmentSize)
        
        let segmentOffset = CGPoint(x: segmentRadius - segmentSize.width / 2, y: segmentRadius - segmentSize.height / 2)
        
        if shouldAnimate {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = 2 * Double.pi
            rotationAnimation.duration = 4.0
            rotationAnimation.repeatCount = .infinity
            
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            positionAnimation.path = UIBezierPath(arcCenter: arrow.position,
                                                  radius: segmentRadius - segmentSize.width / 2,
                                                  startAngle: 0,
                                                  endAngle: 2 * CGFloat.pi,
                                                  clockwise: true).cgPath
            positionAnimation.calculationMode = .paced
            positionAnimation.duration = 4.0
            positionAnimation.repeatCount = .infinity
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [rotationAnimation, positionAnimation]
            groupAnimation.duration = 4.0
            groupAnimation.repeatCount = .infinity
            
            segmentLayer.add(groupAnimation, forKey: "rotationPositionAnimation")
        }
        
        segmentLayer.position = CGPoint(x: arrow.position.x + segmentOffset.x, y: arrow.position.y + segmentOffset.y)

        view.layer.insertSublayer(segmentLayer, below: arrow)
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}

extension UIColor {
    convenience init(hexFromString: String, alpha: CGFloat = 1.0) {
        var cString: String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt32 = 10066329
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            if let hexValue = UInt32(cString, radix: 16) {
                rgbValue = hexValue
            }
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
