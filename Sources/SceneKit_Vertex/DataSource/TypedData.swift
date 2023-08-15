//
//  Created by narumij on 2023/06/11.
//

import SceneKit


public struct TypedData<Vertex> {
    
    public init(data: Data, count: Int? = nil) {
        self.data = data
        self.count = count ?? data.count / MemoryLayout<Vertex>.stride
    }
    
    let data: Data
    
    public let count: Int
}

extension TypedData where Vertex: ComponentType {
    
    typealias Element = Vertex

    public func geometrySource(semantic: SCNGeometrySource.Semantic) -> [SCNGeometrySource] {
        
        [SCNGeometrySource(
            data:               data,
            semantic:            semantic,
            vectorCount:         count,
            usesFloatComponents: Vertex.usesFloatComponents,
            componentsPerVector: Vertex.componentsPerVector,
            bytesPerComponent:   Vertex.bytesPerComponent,
            dataOffset:          0,
            dataStride:          MemoryLayout<Vertex>.stride
        )]
    }
}

extension TypedData where Vertex: InterleavedVertex {
    
    public func geometrySources() -> [SCNGeometrySource] {
        
        Vertex.interleave.map {
            
            SCNGeometrySource(
                data:                data,
                semantic:            $0.semantic,
                vectorCount:         count,
                usesFloatComponents: $0.usesFloatComponents,
                componentsPerVector: $0.componentsPerVector,
                bytesPerComponent:   $0.bytesPerComponent,
                dataOffset:          $0.offset!,
                dataStride:          $0.stride
            )
        }
    }
}

extension TypedData where Vertex: FixedWidthInteger {
    
    public func geometryElements(primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement {
        
        SCNGeometryElement(
            data: data,
            primitiveType: primitiveType,
            primitiveCount: count.primitiveCount(of: primitiveType),
            bytesPerIndex: MemoryLayout<Vertex>.size
        )
    }
}

extension Int {
    
    func primitiveCount(of type: SCNGeometryPrimitiveType ) -> Int {
        
        switch type {
        case .triangleStrip:
            return (self - 2)
        case .triangles:
            return self / 3
        case .line:
            return self / 2
        case .polygon:
            return 1
        default:
            return self
        }
    }
}
