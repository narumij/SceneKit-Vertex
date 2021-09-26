//
//  File.swift
//  
//
//  Created by narumij on 2021/09/26.
//

import SceneKit
import Metal

extension Semantic {
    
    public static func geometry(elementBuffers: [(MTLBuffer, SCNGeometryPrimitiveType)], veretexBuffer: MTLBuffer) -> SCNGeometry {
        let souces = Self.geometrySources( of: veretexBuffer )
        let ele = elementBuffers.map{ Int32.geometryElement( of: $0, primitiveType: $1 ) }
        return SCNGeometry(sources: souces, elements: ele )
    }

    public static func geometry(veretexBuffer: MTLBuffer, primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometry {
        let souces = Self.geometrySources( of: veretexBuffer )
        let ele = geometryElement(from: veretexBuffer, primitiveType: type)
        return SCNGeometry(sources: souces, elements: [ele] )
    }

}

extension Array where Element: Semantic {
    
    public func geometry(with device: MTLDevice, primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometry {
        SCNGeometry( sources: geometrySources( with: device ),
                     elements: [geometryElement( with: device, primitiveType: type )] )

    }
    
}

