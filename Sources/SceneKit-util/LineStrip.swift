//
//  File.swift
//  
//
//  Created by narumij on 2021/10/01.
//

import SceneKit

extension Int
{
    
    fileprivate struct LineStrip
    {
        
        let count: Int
        
        var lineStripIndices: [Int]
        {
            func idx(_ n: Int) -> Int {
                return n / 2 + n % 2
            }
            return count == 0 ? [] : Array<Int>( 0 ..< (count-1)*2).map{ idx($0) }
        }
        
        func geometryElement() -> SCNGeometryElement
        {
            lineStripIndices
                .map({Int32($0)})
                .geometryElement(primitiveType: .line)
        }
        
    }
    
    fileprivate func geometryElement(primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        ( 0 ..< self ).map({ UInt32( $0 ) }).geometryElement(primitiveType: type )
    }
    
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement
    {
        type == .lineStrip
        ? LineStrip(count: self).geometryElement()
        : geometryElement(primitiveType: .init(type))
    }

}

