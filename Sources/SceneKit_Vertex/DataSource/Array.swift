//
//  Created by narumij on 2023/06/11.
//

import SceneKit
import Metal

public extension Array {
    
    var data: Data? {
        
        if isEmpty {
            return nil
        }
        
        return withUnsafeBytes {
            $0.baseAddress.map {
                Data( bytes: $0, count: MemoryLayout<Element>.stride * count )
            }
        }
    }

    func buffer(device: MTLDevice, options: MTLResourceOptions = []) -> MTLBuffer? {
        
        withUnsafeBytes {
            $0.baseAddress.flatMap {
                device.makeBuffer(bytes: $0,
                                  length: count * MemoryLayout<Element>.stride,
                                  options: options )
            }
        }
    }
    
    typealias Vertex = Element
}

extension Array where Element: ComponentType {

    public func geometrySource(semantic: SCNGeometrySource.Semantic) -> [SCNGeometrySource] {
        
        guard let data else { return [] }
        
        return [SCNGeometrySource(
            data:                data,
            semantic:            semantic,
            vectorCount:         count,
            usesFloatComponents: Element.usesFloatComponents,
            componentsPerVector: Element.componentsPerVector,
            bytesPerComponent:   Element.bytesPerComponent,
            dataOffset:          0,
            dataStride:          MemoryLayout<Element>.stride
        )]
    }
}

extension Array where Element: InterleavedVertex {
    
    public func geometrySources() -> [SCNGeometrySource] {
        
        guard let data else { return [] }

        return Element.interleave.map {
            
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

extension Array where Element: FixedWidthInteger {
    
    public func geometryElements(primitiveType: SCNGeometryPrimitiveType) -> SCNGeometryElement {
        SCNGeometryElement(
            indices: self,
            primitiveType: primitiveType
        )
    }
}

public protocol PolygonElement {
    associatedtype Element: FixedWidthInteger
    var polygon: (count: Element, indices: [Element]) { get }
}

extension Array: PolygonElement where Element: FixedWidthInteger {
    public var polygon: (count: Element, indices: [Element]) { (Element(count), self) }
}

extension Array where Element: PolygonElement {

    public func polygonGeometryElements() -> SCNGeometryElement  {
        let polygons = map{ $0.polygon }
        return SCNGeometryElement(indices: polygons.map{$0.count} + polygons.flatMap{$0.indices},
                                  primitiveType: .polygon,
                                  primitiveCount: polygons.count)
    }
}
