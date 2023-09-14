import SceneKit
import Metal

/* 警告が出ない */
@available(*, deprecated, renamed: "elements")
@freestanding(expression)
public macro element<T: FixedWidthInteger>(primitiveType: SCNGeometryPrimitiveType, _ item: [T]) -> GeometryBuilder.Elements = #externalMacro(module: "SCNVertexMacros", type: "ElementArrayMacro")

/* 警告が出ない */
@available(*, deprecated, renamed: "elements")
@freestanding(expression)
public macro element<T: FixedWidthInteger>(primitiveType: SCNGeometryPrimitiveType, data: Data, count: Int? = nil) -> GeometryBuilder.Elements = #externalMacro(module: "SCNVertexMacros", type: "ElementDataMacro")

/* 警告が出ない */
@available(*, deprecated, renamed: "elements")
@freestanding(expression)
public macro element<T: FixedWidthInteger>(primitiveType: SCNGeometryPrimitiveType, buffer: MTLBuffer, count: Int? = nil) -> GeometryBuilder.Elements = #externalMacro(module: "SCNVertexMacros", type: "ElementBufferMacro")
