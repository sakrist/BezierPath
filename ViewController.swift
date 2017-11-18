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

class ViewController: OSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        let test = "P"
        
        let path = test.bezierPath(font: OSFont.init(name: "Helvetica", size: 300)!)
        path.transform(using: AffineTransform.init(scaleByX: 1, byY: -1))
        path.transform(using: AffineTransform.init(translationByX: 0, byY: path.bounds.height + 100))
        
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
        
        let triangles = path.triangles()
        
        let end = Date().timeIntervalSince1970
        print("time: \(end - start)")
        
        print("triangles \(triangles.count) ")
        
        let layer:CALayer? = self.view.layer
        if let baseLayer = layer {
            baseLayer.backgroundColor = OSColor.white.cgColor
        
            for triangle in triangles {
                let triangleLayer = CAShapeLayer()
                triangleLayer.frame = baseLayer.frame
                triangleLayer.path = triangle.toPath()
                triangleLayer.fillColor = OSColor().randomColor().cgColor
                triangleLayer.backgroundColor = OSColor.clear.cgColor
                baseLayer.addSublayer(triangleLayer)
            }
            
            
            let path2:CGMutablePath = CGMutablePath.init()
            
            for segment in path.segments() {
                for point in segment.points {
                    path2.addRect(CGRect.init(x: point.x, y: point.y, width: 0.5, height: 0.5))
                }
            }
            // Style Square
            let a = CAShapeLayer()
            a.path = path2
            a.strokeColor = OSColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
            a.fillColor = nil
            a.opacity = 1.0
            a.lineWidth = 1
            baseLayer.addSublayer(a)
        }
    }

#if os(OSX)
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

