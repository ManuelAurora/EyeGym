import UIKit
import QuartzCore


class AnimatedMaskLabel: UIView {
    
    let gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.5)
        
        let colors = [
            UIColor.cyan.cgColor,
            UIColor.blue.cgColor,
            UIColor.white.cgColor,
            UIColor.blue.cgColor,
            UIColor.cyan.cgColor
        ]
        
        let locations = [
            0.15,
            0.25,
            0.50,
            0.75,
            0.85
        ]
        
        gradientLayer.colors    = colors
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        
        return gradientLayer
    }()
    
    let textAttributes: [String: AnyObject] = {
        
        let style = NSMutableParagraphStyle()
        
        style.alignment = .center
        
        return [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 28.0)!,
            NSParagraphStyleAttributeName: style
        ]
    }()
    
    var text: String! {
        didSet
        {
            setNeedsDisplay()
            
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            
            text.draw(in: bounds, withAttributes: textAttributes)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            let maskLayer = CALayer()
            
            maskLayer.backgroundColor = UIColor.clear.cgColor
            maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
            maskLayer.contents = image!.cgImage
            gradientLayer.mask = maskLayer
        }
    }
    
    override func layoutSubviews() {
        layer.borderColor   = UIColor.green.cgColor
        
        gradientLayer.frame = CGRect(
            x: -bounds.size.width,
            y: bounds.origin.y,
            width:  bounds.size.width * 3,
            height: bounds.size.height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        
        gradientAnimation.fromValue   = [0.0, 0.0, 0.0, 0.0, 0.25]
        gradientAnimation.toValue     = [0.75, 1.0, 1.0, 1.0, 1.0]
        gradientAnimation.duration    = 3.0
        gradientAnimation.repeatCount = Float.infinity
        
        gradientLayer.add(gradientAnimation, forKey: nil)
        
        layer.addSublayer(gradientLayer)
    }
    
}
