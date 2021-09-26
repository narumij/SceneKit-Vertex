//
//  File.swift
//  
//
//  Created by narumij on 2021/09/24.
//

import SceneKit

extension FixedWidthInteger {
    
    public static func geometryElement( of elementBuffer: MTLBuffer,
                                        primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        Array<Self>.geometryElement(of: elementBuffer, primitiveType: primitiveType)
    }
    
}

extension FixedWidthInteger {
    static var dataStride: Int { MemoryLayout<Self>.stride }
    public static func elementCount(of elementBuffer: MTLBuffer) -> Int
    {
        elementBuffer.length / dataStride
    }
}


extension Int {
    
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


extension Array where Element: FixedWidthInteger {
    
    public func geometryElement(primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        SCNGeometryElement(indices: self, primitiveType: type )
    }
    
    public func geometryElement(with device: MTLDevice,
                                primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        Self.geometryElement(of: buffer(with: device)!, primitiveType: type)
    }
    
    public static func geometryElement(of elementBuffer: MTLBuffer,
                                       primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        
        if #available(macOS 11.0, *) {
            return SCNGeometryElement(buffer: elementBuffer,
                                      primitiveType: primitiveType,
                                      primitiveCount: Element.elementCount(of: elementBuffer).primitiveCount(of: primitiveType),
                                      bytesPerIndex: MemoryLayout<Element>.stride)
            
        } else {
            // Fallback on earlier versions
            return SCNGeometryElement( indices: Self( of: elementBuffer ), primitiveType: primitiveType )
            
        }
        
    }
    
}


extension Semantic {
    
    public static func geometryElement(from vertexBuffer: MTLBuffer,
                                       primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        (0..<vertexCount(of: vertexBuffer))
            .map({ UInt32($0) })
            .geometryElement(with: vertexBuffer.device, primitiveType: type)
    }

}

extension Array where Element: Semantic {
    
    public func geometryElement(with device: MTLDevice,
                                primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        (0..<count).map({ UInt32($0) })
            .geometryElement(with: device, primitiveType: type)
    }

}

