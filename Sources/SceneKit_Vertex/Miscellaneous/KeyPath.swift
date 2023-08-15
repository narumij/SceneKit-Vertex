//
//  Created by narumij on 2023/06/11.
//

import Metal

extension KeyPath: Component where Value: ComponentType {
    
    public var usesFloatComponents: Bool { Value.usesFloatComponents }
    public var componentsPerVector: Int  { Value.componentsPerVector }
    public var bytesPerComponent:   Int  { Value.bytesPerComponent }
}

extension KeyPath: Layout {
    
    public var offset: Int? { MemoryLayout<Root>.offset(of: self) }
    public var stride: Int  { MemoryLayout<Root>.stride }
}

// MARK: -

extension KeyPath: VertexFormat where Value: VertexFormatType {
    
    public var vertexFormat: MTLVertexFormat { Value.vertexFormat }
}

// MARK: -

public typealias AttributeKeyPath = Component & Layout

public protocol AttributeProperties {
    var keyPath: AttributeKeyPath { get }
}

extension AttributeProperties {
    public var usesFloatComponents: Bool { keyPath.usesFloatComponents }
    public var componentsPerVector: Int  { keyPath.componentsPerVector }
    public var bytesPerComponent:   Int  { keyPath.bytesPerComponent }
    public var offset:              Int? { keyPath.offset }
    public var stride:              Int  { keyPath.stride }
}

