//
//  BezierPathSampleTests.swift
//  BezierPathSampleTests
//
//  Created by Volodymyr Boichentsov on 03/07/2017.
//  Copyright © 2017 Volodymyr Boichentsov. All rights reserved.
//

import XCTest
@testable import BezierPathSample
import Delaunay

class BezierPathSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let path:OSBezierPath = OSBezierPath.init(roundedRect: CGRect.init(x: 10, y: 10, width: 150, height: 130), cornerRadius: 20)
        path.appendOval(in: CGRect.init(x: 60, y: 60, width: 100, height: 100))
        path.appendOval(in: CGRect.init(x: 100, y: 100, width: 150, height: 130))
        path.appendOval(in: CGRect.init(x: 50, y: 50, width: 150, height: 130))
        path.appendOval(in: CGRect.init(x: 150, y: 150, width: 150, height: 130))
        path.appendOval(in: CGRect.init(x: 250, y: 50, width: 150, height: 130))
        path.appendOval(in: CGRect.init(x: 150, y: 50, width: 150, height: 130))
        path.appendOval(in: CGRect.init(x: 200, y: 50, width: 150, height: 130))
        
        
        _ = path.triangles()
    }
    
    func testPerformanceExample() {
        let path:OSBezierPath = OSBezierPath.init(roundedRect: CGRect.init(x: 10, y: 10, width: 150, height: 130), cornerRadius: 20)
        path.appendOval(in: CGRect.init(x: 60, y: 60, width: 100, height: 100))
        
        
        
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            _ = path.triangles()
        }
    }
    
}
