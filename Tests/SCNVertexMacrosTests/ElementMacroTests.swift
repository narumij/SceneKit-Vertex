import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SCNVertexMacros

fileprivate let arrayMacros: [String: Macro.Type] = [
    "element": ElementArrayMacro.self,
]

fileprivate let dataMacro: [String: Macro.Type] = [
    "element": ElementDataMacro.self,
]

fileprivate let bufferMacros: [String: Macro.Type] = [
    "element": ElementBufferMacro.self,
]

final class ElementMacroTests: XCTestCase {
    
    func testElement0() {
        
        assertMacroExpansion(
            #"""
            #element<UInt32>(primitiveType: .triangles, buffer: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Element(element: TypedBuffer<UInt32>(buffer: b), primitiveType: .triangles)
            """#,
            macros: bufferMacros)
    }
    
    func testElement1() {
        
        assertMacroExpansion(
            #"""
            #element<UInt32>(primitiveType: .triangles, buffer: b, count: 3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Element(element: TypedBuffer<UInt32>(buffer: b, count: 3), primitiveType: .triangles)
            """#,
            macros: bufferMacros)
    }

    func testElement10() {

        assertMacroExpansion(
            #"""
            #element(primitiveType: .triangles, buffer)
            """#,
            expandedSource:
            #"""
            SceneKit_Vertex.GeometryBuilder.Element(element: buffer, primitiveType: .triangles)
            """#,
            macros: arrayMacros)
    }

    func testElement2() {

        assertMacroExpansion(
            #"""
            #element<UInt32>(primitiveType: .triangles, [0,1,2,3,4,5])
            """#,
            expandedSource:
            #"""
            SceneKit_Vertex.GeometryBuilder.Element(element: ([0, 1, 2, 3, 4, 5]) as [UInt32], primitiveType: .triangles)
            """#,
            macros: arrayMacros)
    }
    
    func testElement3() {
        
        assertMacroExpansion(
            #"""
            #element<UInt32>(primitiveType: .triangles, data: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Element(element: TypedData<UInt32>(data: b), primitiveType: .triangles)
            """#,
            macros: dataMacro)
    }
    
    func testElement4() {
        
        assertMacroExpansion(
            #"""
            #element<UInt32>(primitiveType: .triangles, data: b, count: 3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Element(element: TypedData<UInt32>(data: b, count: 3), primitiveType: .triangles)
            """#,
            macros: dataMacro)
    }
}
