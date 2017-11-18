//
//  BezierPath.swift
//  BezierPath
//
//  Created by Volodymyr Boichentsov on 03/07/2017.
//  Copyright © 2017 Volodymyr Boichentsov. All rights reserved.
//

import Foundation
import Delaunay

public struct Point {
    public var x:Double
    public var y:Double
    
    public init(x: Double, y: Double) {
        self.x = x;
        self.y = y;
    }
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = Double(x);
        self.y = Double(y);
    }
    
    public init(x: Int, y: Int) {
        self.x = Double(x);
        self.y = Double(y);
    }
    
    public init(_ point: CGPoint) {
        self.x = Double(point.x);
        self.y = Double(point.y);
    }
}

@objc open class Segment: NSObject {
    open var points:[Point] = []
    init(_ points:[Point]) {
        self.points.append(contentsOf: points) 
    }
}

public extension Vertex {
    public init(_ point:Point, _ i:Int) {
        self.init(x:point.x, y:point.y, i:i)
    }
}

public enum PathElement {
    case moveToPoint(Point)
    case addLineToPoint(Point)
    case addQuadCurveToPoint(Point, Point)
    case addCurveToPoint(Point, Point, Point)
    case closeSubpath
}

import CoreGraphics


// https://oleb.net/blog/2015/06/c-callbacks-in-swift/
extension PathElement {
    init(element: CGPathElement) {
        switch element.type {
        case .moveToPoint:
            self = .moveToPoint(Point(element.points[0]))
        case .addLineToPoint:
            self = .addLineToPoint(Point(element.points[0]))
        case .addQuadCurveToPoint:
            self = .addQuadCurveToPoint(Point(element.points[0]), Point(element.points[1]))
        case .addCurveToPoint:
            self = .addCurveToPoint(Point(element.points[0]), Point(element.points[1]), Point(element.points[2]))
        case .closeSubpath:
            self = .closeSubpath
        }
    }
}

#if os(OSX)
    import Cocoa
    public typealias OSBezierPath = NSBezierPath 
    
    extension PathElement {
        init(type: NSBezierPathElement, points: NSPointArray) {
            switch type {
            case .moveToBezierPathElement:
                self = .moveToPoint(Point(points[0]))
            case .lineToBezierPathElement:
                self = .addLineToPoint(Point(points[0]))
            case .curveToBezierPathElement:
                self = .addCurveToPoint(Point(points[0]), Point(points[1]), Point(points[2]))
            case .closePathBezierPathElement:
                self = .closeSubpath
            }
        }
    }
    
    extension NSBezierPath {
        
        public convenience init(cgPath CGPath:CGPath) {
            var elements = [PathElement]()
            CGPath.applyWithBlock({ (elementPtr) in
                let element = elementPtr.pointee
                elements.append(PathElement.init(element: element))
            })
            self.init(elements:elements)   
        }
        
        var elements: [PathElement] {
            var pathElements = [PathElement]()
            
            for i in 0..<self.elementCount  {
                
                let points = NSPointArray.allocate(capacity: 3)   
                let elementType = self.element(at: i, associatedPoints: points)
                let nextElement = PathElement(type:elementType, points:points)
                pathElements.append(nextElement)
                points.deallocate(capacity: 3)
            }
            
            return pathElements
        }
    
        public convenience init(elements elm:[PathElement]) {
            self.init()
                        
            for element in elm {
                
                switch element {
                case let .moveToPoint(point):
                    self.move(to: NSPoint(x: point.x, y: point.y))
                    break
                case let .addLineToPoint(point):
                    self.line(to: NSPoint(x: point.x, y: point.y))
                    break
                case let .addQuadCurveToPoint(point1, point2):
                    
                    let current = self.currentPoint
                    let cp1 = NSPoint(x: Double(current.x) + (2.0/3.0 * (point1.x - Double(current.x))) , y: Double(current.y) + (2.0/3.0 * (point1.y - Double(current.y))))
                    let cp2 = NSPoint(x: point2.x + (2.0/3.0 * (point1.x - point2.x)) , y: point2.y + (2.0/3.0 * (point1.y - point2.y)))
                    
                    self.curve(to: NSPoint(x: point2.x, y: point2.y), controlPoint1: cp1, controlPoint2: cp2)                    
                    break
                case let .addCurveToPoint(point1, point2, point3):
                    self.curve(to: NSPoint(x: point3.x, y: point3.y), controlPoint1: NSPoint(x: point1.x, y: point1.y), controlPoint2: NSPoint(x: point2.x, y: point2.y))
                    break
                case .closeSubpath:
                    self.close()
                    break
                }
            }
        }
        
        public convenience init(roundedRect:CGRect, cornerRadius: CGFloat) {
            
//            self.init()
//            if !roundedRect.isEmpty {
//                if cornerRadius > 0.0 {
//                    let clampedRadius = min(cornerRadius, 0.5 * min(roundedRect.size.width, roundedRect.size.height))
//                    
//                    let topLeft = CGPoint.init(x:roundedRect.minX, y:roundedRect.minY)
//                    let topRight = CGPoint.init(x:roundedRect.maxX, y:roundedRect.maxY)
//                    let bottomRight = CGPoint.init(x:roundedRect.maxX, y:roundedRect.minY)
//
//                    self.move(to: CGPoint.init(x:roundedRect.midX, y:roundedRect.maxY))
//                    self.appendArc(from: topLeft, to: roundedRect.origin, radius: clampedRadius)
//                    self.appendArc(from: roundedRect.origin, to: bottomRight, radius: clampedRadius)
//                    self.appendArc(from: bottomRight, to: topRight, radius: clampedRadius)
//                    self.appendArc(from: topRight, to: topLeft, radius: clampedRadius)
//                    self.close()
//                    
//                } else {
//                    self.appendRect(roundedRect);
//                }
//            }
            
            
            self.init(roundedRect:roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
        }
    }
    
#elseif os(iOS)
    import UIKit
    public typealias OSBezierPath = UIBezierPath
    
    extension UIBezierPath {
        var elements: [PathElement] {
            var pathElements:[PathElement] = []
            withUnsafeMutablePointer(to: &pathElements) { elementsPointer in
                let rawElementsPointer = UnsafeMutableRawPointer(elementsPointer)
                cgPath.apply(info: rawElementsPointer) { userInfo, nextElementPointer in
                    let nextElement = PathElement(element: nextElementPointer.pointee)
                    let elementsPointer = userInfo?.assumingMemoryBound(to: [PathElement].self)
                    elementsPointer?.pointee.append(nextElement)
                }
            }
            return pathElements
        }
        
        public func appendOval(in rect:CGRect) {
            self.append(UIBezierPath.init(ovalIn: rect))
        }
        
        public var elementCount:Int {
            return self.elements.count
        }
    }
    
#endif


func bezierQubicPointAt(_ points: [Point], t:Double ) -> Point {
    let x:Double = pow((1.0-t), 3) * points[0].x + 3.0 * pow((1.0-t), 2) * t * points[1].x + 3.0 * (1.0-t) * pow(t, 2) * points[2].x + pow(t, 3) * points[3].x
    let y:Double = pow((1.0-t), 3) * points[0].y + 3.0 * pow((1.0-t), 2) * t * points[1].y + 3.0 * (1.0-t) * pow(t, 2) * points[2].y + pow(t, 3) * points[3].y
    return Point(x:x, y:y)
}

func bezierQuadraticPointAt(_ points: [Point], t:Double ) -> Point {
    let x = pow((1.0-t), 2) * points[0].x + 2 * (1 - t) * t * points[1].x + pow(t, 2) * points[2].x;
    let y = pow((1.0-t), 2) * points[0].y + 2 * (1 - t) * t * points[1].y + pow(t, 2) * points[2].y;
    return Point(x:x, y:y)
}



extension OSBezierPath {

   open func segments() -> [Segment] { 
        var segments = [Segment]()
        
        segments.removeAll()
        var lastPoint:Point = Point(x:0, y:0)
        
        for element in self.elements {
            
            var segmentPoints:[Point] = []
            
            switch element {
            case let .moveToPoint(point):
                
                lastPoint = point
                break
            case let .addLineToPoint(point):
                segmentPoints.append(lastPoint)
                segmentPoints.append(point)
                lastPoint = point
                break
            case let .addQuadCurveToPoint(point1, point2):
                var t:Double = 0.0
                while t < 1.0 {
                    let points:[Point] = [lastPoint, point1, point2]
                    let point:Point = bezierQuadraticPointAt(points, t: t)
                    segmentPoints.append(point)
                    t += 0.1
                }
                lastPoint = point2
                break
            case let .addCurveToPoint(point1, point2, point3):
                var t:Double = 0.0
                while t < 1.0 {
                    let points:[Point] = [lastPoint, point1, point2, point3]
                    let point:Point = bezierQubicPointAt(points, t: t)
                    segmentPoints.append(point)
                    t += 0.1
                }
                
                lastPoint = point3
                break
            case .closeSubpath:
                break
            }
            
            if segmentPoints.count > 0 {
                let segment:Segment = Segment.init(segmentPoints);
                segments.append(segment)
            }
        }
        // finish
        return segments
    }
    
    open func triangles() -> [Triangle] { 
        
        var vertices = [Vertex]()
        var index:Int = 0
        for segment in self.segments() {
            for point in segment.points {
                vertices.append(Vertex(point, index))
                index += 1
            }
        }
        
//        return CDT().triangulate(vertices)
        return Delaunay().triangulate(vertices)
    } 
}






