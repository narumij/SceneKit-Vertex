//
//  Created by narumij on 2023/06/12.
//

import SceneKit

public extension SCNGeometry {
    
    /// Generating custom SCNGeometry from vertex data
    ///
    /// Vertex indices are not required.
    ///
    /// The macros available in GeometrySourceBuilder are as follows:
    ///
    /// ```swift
    /// #interleave
    /// #vertex
    /// #normal
    /// #color
    /// #texcoord
    /// #tangent
    /// #vertexCrease
    /// #edgeCrease
    /// #boneWeights
    /// #boneIndices
    /// ```
    /// An example of usage:
    /// ```swift
    /// let geom = SCNGeometry(primitiveType: .triangleStrip) {
    ///     #vertex<SIMD3<Float>>([[-1,-1,0], [1,-1,0], [-1,1,0], [1,1,0]])
    ///     #color<SIMD3<Float>>([[0,0,0], [1,0,0], [0,1,0], [1,1,0]])
    /// }
    ///
    convenience init(primitiveType: SCNGeometryPrimitiveType, @GeometrySourceBuilder _ children: () -> [SCNGeometrySource]) {
        
        let sources: [SCNGeometrySource] = children()
        
        let elements = (sources.first{ $0.semantic == .vertex } ?? sources.first).map {
            [ SCNGeometryElement(vectorCount: $0.vectorCount, primitiveType: primitiveType) ]
        }
        
        self.init(sources: sources, elements: elements)
    }
    
    /// Generates custom SCNGeometry from vertex data.
    ///
    /// Vertex indices are required.
    ///
    /// The macros available in GeometryBuilder are as follows:
    ///
    /// ```swift
    /// #interleave
    /// #vertex
    /// #normal
    /// #color
    /// #texcoord
    /// #tangent
    /// #vertexCrease
    /// #edgeCrease
    /// #boneWeights
    /// #boneIndices
    ///
    /// #element
    /// #polygon
    /// ```
    ///
    /// An example of usage:
    /// ```swift
    /// let geom = SCNGeometry {
    ///     #vertex<SIMD3<Float>>([[-1,-1,0], [1,-1,0], [-1,1,0], [1,1,0]])
    ///     #color<SIMD3<Float>>([[0,0,0], [1,0,0], [0,1,0], [1,1,0]])
    ///     #element<UInt32>(primitiveType: .triangleStrip, [0,1,2,3])
    /// }
    /// ```
    convenience init(@GeometryBuilder _ children: () -> (sources: [SCNGeometrySource], elements: [SCNGeometryElement])) {
        
        let component = children()
        
        self.init(sources: component.sources, elements: component.elements)
    }
}
