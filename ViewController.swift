//
//  ViewController.swift
//  BezierPathSample
//
//  Created by Volodymyr Boichentsov on 03/07/2017.
//  Copyright © 2017 Volodymyr Boichentsov. All rights reserved.
//

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

import Delaunay

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { 
        completion()
    }
}

class ViewController: OSViewController {

    var flattness = 0.7
    var baseLayer:CAGradientLayer = CAGradientLayer.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        let layer:CALayer? = self.view.layer
        
        baseLayer.frame = CGRect.init(origin: CGPoint.zero, size: baseLayer.frame.size)
//        baseLayer.colors = [OSColor().randomColor().cgColor, OSColor().randomColor().cgColor, OSColor().randomColor().cgColor]
        layer?.addSublayer(baseLayer)
        baseLayer.borderWidth = 0

#if os(OSX)
        baseLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
#endif
        
        testTextTriangle()
        
    }
    
#if os(OSX)
    @IBAction func flatness(_ sender: NSSlider) {
        flattness = sender.doubleValue
        testTextTriangle()
    }
#endif
    
    func testTextTriangle() {
        
        if let subs = baseLayer.sublayers {
            for s in subs {
                s.removeFromSuperlayer()
            }
        }
        
        // Do any additional setup after loading the view.

        let test = "Super"
        
        let path = test.bezierPath(font: OSFont.init(name: "Helvetica", size: 200)!)
        path.transform(using: OSAffineTransform.init(scaleByX: 1, byY: -1))
        path.transform(using: OSAffineTransform.init(translationByX: 0, byY: path.bounds.height + 100))
        
//        let path:OSBezierPath = OSBezierPath.init(roundedRect: CGRect.init(x: 10, y: 10, width: 150, height: 130), cornerRadius: 50)
//        
//        path.appendOval(in: CGRect.init(x: 100, y: 100, width: 150, height: 130))
//        path.appendOval(in: CGRect.init(x: 50, y: 50, width: 150, height: 130))
//        path.appendOval(in: CGRect.init(x: 150, y: 150, width: 150, height: 130))
//        path.appendOval(in: CGRect.init(x: 250, y: 50, width: 150, height: 130))
//        path.appendOval(in: CGRect.init(x: 150, y: 50, width: 150, height: 130))
//        path.appendOval(in: CGRect.init(x: 200, y: 50, width: 150, height: 130))
//        path.appendOval(in: CGRect.init(x: 200, y: 50, width: 150, height: 130))
        
        
        
        let start = Date().timeIntervalSince1970
        
        let triangles = path.triangles(flatness: flattness)
//        let triangles = [Triangle]()
        let end = Date().timeIntervalSince1970
        print("time: \(end - start)")
        
        print("triangles \(triangles.count) ")
        
           
            
            for triangle in triangles {
                let triangleLayer = CAShapeLayer()
                triangleLayer.frame = baseLayer.frame
                triangleLayer.path = triangle.toPath()
                triangleLayer.borderWidth = 0.5
                triangleLayer.strokeColor = OSColor.black.cgColor
                triangleLayer.fillColor = OSColor.gray.cgColor
                triangleLayer.fillColor = OSColor().randomColor().cgColor
                triangleLayer.backgroundColor = OSColor.clear.cgColor
                baseLayer.addSublayer(triangleLayer)
            }
            
            
            // Style Square
            let a = CAShapeLayer()
            a.path = path.cgPath
            a.strokeColor = OSColor().randomColor().cgColor
            a.fillColor = nil
            a.opacity = 1.0
            a.lineWidth = 1
            baseLayer.addSublayer(a)
            
            
//            for segment in path.polygons() {
//                let path2:CGMutablePath = CGMutablePath.init()
//                for point in segment.points {
//                    path2.addRect(CGRect.init(x: point.x, y: point.y, width: 0.5, height: 0.5))
//                }
//                // Style Square
//                let a = CAShapeLayer()
//                a.path = path2
//                a.strokeColor = OSColor().randomColor().cgColor
//                a.fillColor = nil
//                a.opacity = 1.0
//                a.lineWidth = 1
//                baseLayer.addSublayer(a)
//            }

    }
    
#if os(OSX)
    
    override func viewDidLayout() {
        self.view.layer?.frame = self.view.bounds 
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
#elseif os(iOS)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
#endif


}

