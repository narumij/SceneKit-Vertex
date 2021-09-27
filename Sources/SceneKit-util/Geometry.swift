//
//  File.swift
//  
//
//  Created by narumij on 2021/09/26.
//

import SceneKit
import Metal


extension GeometrySource {

    public func geometry(primitiveType type: PrimitiveType) -> SCNGeometry? {
        geometryElement(primitiveType: type)
            .map{ SCNGeometry( sources: geometrySources(),
                               elements: [$0] ) }
    }

    public func geometry<T: FixedWidthInteger>(elements: [([T], SCNGeometryPrimitiveType)]) -> SCNGeometry {
        SCNGeometry( sources: geometrySources(),
                     elements: elements.map{ $0.geometryElement(primitiveType: $1 ) })
    }
    
    public func geometry(elements: [(MTLBuffer, SCNGeometryPrimitiveType)]) -> SCNGeometry {
        SCNGeometry( sources: geometrySources(),
                     elements: elements.map{ Array<Int32>.geometryElement( of: $0, primitiveType: $1 ) } )
    }

}

