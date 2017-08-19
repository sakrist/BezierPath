//
//  BezierPathDelaunay.swift
//  BezierPathSample
//
//  Created by Volodymyr Boichentsov on 19/08/2017.
//  Copyright © 2017 Volodymyr Boichentsov. All rights reserved.
//

import Foundation
import DelaunaySwift 


extension BezierPath {
    open func triangles() -> [Triangle] {        
        
        var vertices = [Vertex]()
        
        for segment in self.segments {
            for point in segment.points {
                vertices.append(Vertex(point))
            }
        }
        
        return Delaunay().triangulate(vertices)
    } 
}
