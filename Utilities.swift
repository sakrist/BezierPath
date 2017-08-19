//
//  Utilities.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

#if os(iOS)
    import UIKit
    public typealias OSColor = UIColor
    public typealias OSViewController = UIViewController
#elseif os(OSX)
    import Cocoa
    public typealias OSColor = NSColor
    public typealias OSViewController = NSViewController
#endif

import DelaunaySwift

extension Triangle {
    func toPath() -> CGPath {
        
        let path = CGMutablePath()
        let point1 = self.v1()
        let point2 = self.v2()
        let point3 = self.v3()
        
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point1)

        path.closeSubpath()
        
        return path
    }
}

public extension Vertex {
    public init(_ point:Point) {
        self.init(x:point.x, y:point.y)
    }
}

extension Double {
    static func random() -> Double {
        return Double(arc4random()) / 0xFFFFffff
    }
    
    static func random(_ min: Double, _ max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

extension CGFloat {
    static func random(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
        return CGFloat(Double.random(Double(min), Double(max)))
    }
}

extension OSColor {
    func randomColor() -> OSColor {
        let hue = CGFloat( Double.random() )  // 0.0 to 1.0
        let saturation: CGFloat = 0.5  // 0.5 to 1.0, away from white
        let brightness: CGFloat = 1.0  // 0.5 to 1.0, away from black
        let color = OSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color
    }
}
