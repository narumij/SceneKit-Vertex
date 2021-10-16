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
    
    /// MTLBufferでArrayを初期化する
    public init(_ buffer: MTLBuffer ) {
        
        let pointer = buffer.contents().bindMemory( to: Element.self, capacity: buffer.length )
        let bufferPointer = UnsafeBufferPointer<Element>( start: pointer, count: buffer.length / MemoryLayout<Element>.stride )
        self.init( bufferPointer )
    }
    
    /// ArrayからMTLBufferを生成する
    public func buffer( _ device: MTLDevice, options: MTLResourceOptions = [] ) -> MTLBuffer? {
        
        device.makeBuffer(bytes: self,
                          length: count * MemoryLayout<Element>.size,
                          options: options )
    }
    
    /// MTLBufferが保持する要素数を返す
    public static func count(of buffer: MTLBuffer) -> Int {
        
        buffer.length / stride
    }
    
}

extension Array {
    
    var stride: Int {
        
        Self.stride
    }
    
    static var stride: Int {
        
        MemoryLayout<Element>.stride
    }
    
}

extension Array {
    
    func geometryElement(primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement {
        
        (0..<count)
            .map({ UInt32($0) })
            .geometryElement(primitiveType: type)
    }
    
    static func geometryElement(buffer: MTLBuffer,
                                primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement? {
        
        (0..<count(of: buffer))
            .map({ UInt32($0) })
            .geometryElement(primitiveType: type)
    }

}

extension Array {

    static func geometrySource(buffer: MTLBuffer,
                               semantic: SCNGeometrySource.Semantic,
                               vertexFormat: MTLVertexFormat) -> SCNGeometrySource {
        
        SCNGeometrySource(buffer:       buffer,
                          vertexFormat: vertexFormat,
                          semantic:     semantic,
                          vertexCount:  count(of: buffer),
                          dataOffset:   0,
                          dataStride:   stride )
    }

}

// MARK: -

extension Array where Element: FixedWidthInteger {
    
    func geometryElement(primitiveType type: SCNGeometryPrimitiveType) -> SCNGeometryElement {
        
        SCNGeometryElement(indices: self, primitiveType: type )
    }
    
    static func geometryElement(of elementBuffer: MTLBuffer,
                                primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement {
        
        if #available(macOS 11.0, iOS 14.0, *) {
            
            return SCNGeometryElement(buffer: elementBuffer,
                                      primitiveType: primitiveType,
                                      primitiveCount: Array<Element>.count(of: elementBuffer).primitiveCount(of: primitiveType),
                                      bytesPerIndex: stride)
            
        }
        else {
            // Fallback on earlier versions
            return SCNGeometryElement( indices: Self( elementBuffer ), primitiveType: primitiveType )
            
        }
        
    }
    
}


extension Array where Element: BasicInterleave {
    
    fileprivate var data: Data {
        
        Data( bytes: self, count: MemoryLayout<Element>.size * count )
    }
    
    func geometrySources() -> [SCNGeometrySource] {
        
        Element.basicAttributes.map {
            SCNGeometrySource(data:                data,
                              semantic:            $0.semantic,
                              vectorCount:         count,
                              usesFloatComponents: $0.usesFloatComponents,
                              componentsPerVector: $0.componentsPerVector,
                              bytesPerComponent:   $0.bytesPerComponent,
                              dataOffset:          $0.dataOffset,
                              dataStride:          stride )
        }
    }
}

extension Array where Element: MetalInterleave {
    
    static func geometrySources(of vertexBuffer: MTLBuffer ) -> [SCNGeometrySource] {
        
        Element.metalAttributes.map {
            SCNGeometrySource(buffer:       vertexBuffer,
                              vertexFormat: $0.vertexFormat,
                              semantic:     $0.semantic,
                              vertexCount:  count(of: vertexBuffer),
                              dataOffset:   $0.dataOffset,
                              dataStride:   stride )
        }
    }
}

// MARK: - SCNVector, SIMD2, SIMD3, SIMD4

extension Array where Element: BasicVertexDetail {
    
    func geometrySource(semantic: SCNGeometrySource.Semantic) -> SCNGeometrySource {
        
        SCNGeometrySource( data: Data( bytes: self, count: MemoryLayout<Element>.size * count ),
                           semantic: semantic,
                           vectorCount: count,
                           usesFloatComponents: Element.usesFloatComponents,
                           componentsPerVector: Element.componentsPerVector,
                           bytesPerComponent: Element.bytesPerComponent,
                           dataOffset: 0,
                           dataStride: stride )
    }
    
}

extension Array where Element: MetalVertexDetail {
    
    static func geometrySource(of buffer: MTLBuffer, semantic s: SCNGeometrySource.Semantic) -> SCNGeometrySource {
        
        geometrySource(buffer: buffer, semantic: s, vertexFormat: Element.vertexFormat)
    }
    
}

extension Array where Element: BasicInterleave {
    
    func geometryElement(primitiveType type: PrimitiveType) -> SCNGeometryElement {
        
        count.geometryElement(primitiveType: type)
    }

}

