//
//  File.swift
//  
//
//  Created by narumij on 2021/09/27.
//

import SceneKit

public enum PrimitiveType : Int
{
    case triangles = 0
    case triangleStrip = 1
    case line = 2
    case point = 3
    @available(macOS 10.12, *)
    case polygon = 4
    case lineStrip = 5
}


extension SCNGeometryPrimitiveType
{
    init(_ t: PrimitiveType) {
        switch t {
        case .triangles:
            self = .triangles
        case .triangleStrip:
            self = .triangleStrip
        case .line:
            self = .line
        case .point:
            self = .point
        case .polygon:
            self = .polygon
        case .lineStrip:
            fatalError()
        }
    }
    
}

extension Int
{
    func primitiveCount(of type: SCNGeometryPrimitiveType ) -> Int
    {
        switch type {
        case .triangleStrip:
            return (self - 2)
        case .triangles:
            return self / 3
        case .line:
            return self / 2
        default:
            return self
        }
        
    }
    
}

