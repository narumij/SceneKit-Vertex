//
//  Created by narumij on 2021/10/01.
//

import SceneKit
import Metal

public struct TypedBuffer<Vertex> {
    
    public init(buffer: MTLBuffer, count: Int? = nil) {
        self.buffer = buffer
        self.count = count ?? buffer.length / MemoryLayout<Vertex>.stride
    }
    
    let buffer: MTLBuffer
    
    public let count: Int
}

extension TypedBuffer where Vertex: VertexFormatType {
    
    typealias Element = Vertex
    
    public func geometrySource(semantic: SCNGeometrySource.Semantic) -> [SCNGeometrySource] {
        
        geometrySource(semantic: semantic, vertexFormat: Vertex.vertexFormat)
    }
    
    public func geometrySource(semantic: SCNGeometrySource.Semantic, vertexFormat: MTLVertexFormat) -> [SCNGeometrySource] {
        
        [SCNGeometrySource(
            buffer:       buffer,
            vertexFormat: vertexFormat,
            semantic:     semantic,
            vertexCount:  count,
            dataOffset:   0,
            dataStride:   MemoryLayout<Vertex>.stride
        )]
    }
}

extension TypedBuffer where Vertex: InterleavedVertex {
    
    public func geometrySources() -> [SCNGeometrySource] {
        
        Vertex.interleave.map {
            
            SCNGeometrySource(
                buffer:       buffer,
                vertexFormat: $0.vertexFormat,
                semantic:     $0.semantic,
                vertexCount:  count,
                dataOffset:   $0.offset!,
                dataStride:   $0.stride
            )
        }
    }
}

extension TypedBuffer where Vertex: FixedWidthInteger {
    
    @available(macOS 12.0, iOS 14.0, tvOS 14.0, *)
    public func geometryElements(primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement {
        
        SCNGeometryElement(
            buffer: buffer,
            primitiveType: primitiveType,
            primitiveCount: count.primitiveCount(of: primitiveType),
            bytesPerIndex: MemoryLayout<Vertex>.stride
        )
    }
}

public extension TypedBuffer {
    
    /// MTLBufferでArrayを初期化する
    var array: Array<Vertex> {
        
        let pointer = buffer.contents().bindMemory( to: Vertex.self, capacity: buffer.length )
        let bufferPointer = UnsafeBufferPointer<Vertex>( start: pointer, count: buffer.length / MemoryLayout<Vertex>.stride )
        return [Vertex](bufferPointer)
    }
}

