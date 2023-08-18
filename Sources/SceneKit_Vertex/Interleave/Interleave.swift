//
//  Created by narumij on 2021/09/27.
//

import SceneKit
import Metal

public protocol Semantic {
    var semantic: SCNGeometrySource.Semantic { get }
}

public protocol Component {
    
    var usesFloatComponents: Bool { get }
    var componentsPerVector: Int  { get }
    var bytesPerComponent:   Int  { get }
}

public protocol VertexFormat {
    var vertexFormat: MTLVertexFormat { get }
}

public protocol Layout {
    
    var offset: Int? { get }
    var stride: Int  { get }
}

public protocol BasicAttributeProtocol: Semantic & Component & Layout { }

public protocol MetalAttributeProtocol: Semantic & VertexFormat & Layout { }

// MARK: -

public struct InterleaveAttribute: BasicAttributeProtocol & MetalAttributeProtocol & AttributeProperties {
    
    public init<Vertex,Attribute>(keyPath _keyPath: KeyPath<Vertex,Attribute>,
                                  semantic _semantic: SCNGeometrySource.Semantic,
                                  vertexFormat _vertexFormat: MTLVertexFormat? = nil)
    where Attribute: ComponentType & VertexFormatType {
        
        semantic = _semantic
        keyPath  = _keyPath
        vertexFormat = _vertexFormat ?? _keyPath.vertexFormat
    }
    
    public let keyPath:      AttributeKeyPath
    public let semantic:     SCNGeometrySource.Semantic
    public let vertexFormat: MTLVertexFormat
}

public protocol InterleavedVertex {
    static var interleave: [InterleaveAttribute] { get }
}
