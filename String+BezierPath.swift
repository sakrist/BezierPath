//
//  String+BezierPath.swift
//  BezierPathSample
//
//  Created by Volodymyr Boichentsov on 16/11/2017.
//  Copyright © 2017 Volodymyr Boichentsov. All rights reserved.
//

import Foundation

func bridge<T : AnyObject>(obj : T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func bridge<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

func bridgeRetained<T : AnyObject>(obj : T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

func bridgeTransfer<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}

extension String {
    
    func bezierPath(font:OSFont) -> OSBezierPath {
        let ctFont = CTFontCreateWithName(font.familyName as CFString?, font.pointSize, nil)
        let attributed = NSAttributedString.init(string: self, attributes: [kCTFontAttributeName as String: ctFont])        
        let letters = CGMutablePath()
        let line = CTLineCreateWithAttributedString(attributed)
        let runArray = CTLineGetGlyphRuns(line)

        for runIndex in 0..<CFArrayGetCount(runArray) {

            let runRef = CFArrayGetValueAtIndex(runArray, runIndex)
            let run:CTRun = bridge(ptr: runRef!)

            let atts = CTRunGetAttributes(run)
            let key = kCTFontAttributeName
            let keyPtr = bridgeRetained(obj: key)
            let runFontPtr = CFDictionaryGetValue(atts, keyPtr)
            let runFont:CTFont = bridge(ptr: runFontPtr!)
            
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {

                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
                var glyph = CGGlyph()
                var position = CGPoint()
                CTRunGetGlyphs(run, thisGlyphRange, &glyph);
                CTRunGetPositions(run, thisGlyphRange, &position);
                
                let letter = CTFontCreatePathForGlyph(runFont, glyph, nil);
                let t = CGAffineTransform(translationX: position.x, y: position.y);
                if letter != nil {
                    letters.addPath(letter!, transform: t)
                }
            }
        }
        
        let path = OSBezierPath.init(cgPath:letters)

        let boundingBox = letters.boundingBox;
        
        // The path is upside down (CG coordinate system)
        path.transform(using: AffineTransform.init(scaleByX: 1.0, byY: -1.0))
        path.transform(using: AffineTransform.init(translationByX: 0.0, byY: boundingBox.size.height))
        
        return path
        
//        return OSBezierPath.init()
    }
}
