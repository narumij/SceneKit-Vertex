//
//  File.swift
//  
//
//  Created by narumij on 2021/09/24.
//

import Metal
import SceneKit

// MARK: - MTLBuffer

extension Array {
    
    public init(of buffer: MTLBuffer ) {
        let pointer = buffer.contents().bindMemory( to: Element.self, capacity: buffer.length )
        let bufferPointer = UnsafeBufferPointer<Element>( start: pointer, count: buffer.length / MemoryLayout<Element>.stride )
        self.init( bufferPointer )
    }
    
    public func buffer( with device: MTLDevice, options: MTLResourceOptions = [] ) -> MTLBuffer? {
        device.makeBuffer(bytes: self,
                          length: count * MemoryLayout<Element>.size,
                          options: options )
    }
    
}

// MARK: - 整数

extension Array where Element: FixedWidthInteger {
    
    func geometryElement(primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        SCNGeometryElement(indices: self, primitiveType: type )
    }
    
    static func geometryElement(of elementBuffer: MTLBuffer,
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

// MARK: - 頂点構造体

extension Interleave {
    
    static func geometrySources(of vertexBuffer: MTLBuffer ) -> [SCNGeometrySource] {
        Self.geometrySources(of: vertexBuffer, vertexCount: vertexCount(of: vertexBuffer) )
    }

}

extension Array where Element: Interleave {
    
    func geometrySources() -> [SCNGeometrySource] {
        Element.geometrySources(of: data, vertexCount: count)
    }

    var data: Data { Data( bytes: self, count: MemoryLayout<Element>.size * count ) }

}

extension Interleave {
    
    static func geometrySources(of vertexBuffer: MTLBuffer, vertexCount: Int) -> [SCNGeometrySource] {
        
        semanticDetails.map {
            SCNGeometrySource(buffer:       vertexBuffer,
                              vertexFormat: $0.vertexFormat,
                              semantic:     $0.semantic,
                              vertexCount:  vertexCount,
                              dataOffset:   $0.dataOffset,
                              dataStride:   dataStride )
        }
        
    }

    static func geometrySources(of data: Data, vertexCount: Int ) -> [SCNGeometrySource] {
        
        semanticDetails.map {
            SCNGeometrySource(data:                data,
                              semantic:            $0.semantic,
                              vectorCount:         vertexCount,
                              usesFloatComponents: $0.usesFloatComponents,
                              componentsPerVector: $0.componentsPerVector,
                              bytesPerComponent:   $0.bytesPerComponent,
                              dataOffset:          $0.dataOffset,
                              dataStride:          dataStride )
        }
        
    }
    
}

extension Interleave {
    
    static func geometryElement(from vertexBuffer: MTLBuffer,
                                       primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement?
    {
        (0..<vertexCount(of: vertexBuffer))
            .map({ UInt32($0) })
            .geometryElement(primitiveType: type)
    }

}

extension Array where Element: Interleave {
    
    func geometryElement(primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement
    {
        (0..<count).map({ UInt32($0) })
            .geometryElement(primitiveType: type)
    }
}

// MARK: - SCNVector, SIMD2, SIMD3, SIMD4

extension Array where Element: GeometrySourceVector {
    
    func geometrySource(semantic: SCNGeometrySource.Semantic) -> SCNGeometrySource {
        SCNGeometrySource( data: Data( bytes: self, count: MemoryLayout<Element>.size * count ),
                           semantic: semantic,
                           vectorCount: count,
                           usesFloatComponents: Element.usesFloatComponents,
                           componentsPerVector: Element.componentsPerVector,
                           bytesPerComponent: Element.bytesPerComponent,
                           dataOffset: 0,
                           dataStride: MemoryLayout<Element>.stride )
    }
    
}

