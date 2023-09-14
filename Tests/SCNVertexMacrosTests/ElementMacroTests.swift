import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SCNVertexMacros

fileprivate let arrayMacros: [String: Macro.Type] = [
    "elements": ElementArrayMacro.self,
]

fileprivate let dataMacro: [String: Macro.Type] = [
    "elements": ElementDataMacro.self,
]

fileprivate let bufferMacros: [String: Macro.Type] = [
    "elements": ElementBufferMacro.self,
]

final class ElementMacroTests: XCTestCase {
    
    func testElement0() {
        
        assertMacroExpansion(
            #"""
            #elements<UInt32>(primitiveType: .triangles, buffer: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Elements(primitiveType: .triangles, elements: TypedBuffer<UInt32>(buffer: b))
            """#,
            macros: bufferMacros)
    }
    
    func testElement1() {
        
        assertMacroExpansion(
            #"""
            #elements<UInt32>(primitiveType: .triangles, buffer: b, count: 3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Elements(primitiveType: .triangles, elements: TypedBuffer<UInt32>(buffer: b, count: 3))
            """#,
            macros: bufferMacros)
    }

    func testElement10() {

        assertMacroExpansion(
            #"""
            #elements(primitiveType: .triangles, buffer)
            """#,
            expandedSource:
            #"""
            SceneKit_Vertex.GeometryBuilder.Elements(primitiveType: .triangles, elements: buffer)
            """#,
            macros: arrayMacros)
    }

    func testElement2() {

        assertMacroExpansion(
            #"""
            #elements<UInt32>(primitiveType: .triangles, [0,1,2,3,4,5])
            """#,
            expandedSource:
            #"""
            SceneKit_Vertex.GeometryBuilder.Elements(primitiveType: .triangles, elements: ([0, 1, 2, 3, 4, 5]) as [UInt32])
            """#,
            macros: arrayMacros)
    }
    
    func testElement3() {
        
        assertMacroExpansion(
            #"""
            #elements<UInt32>(primitiveType: .triangles, data: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Elements(primitiveType: .triangles, elements: TypedData<UInt32>(data: b))
            """#,
            macros: dataMacro)
    }
    
    func testElement4() {
        
        assertMacroExpansion(
            #"""
            #elements<UInt32>(primitiveType: .triangles, data: b, count: 3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Elements(primitiveType: .triangles, elements: TypedData<UInt32>(data: b, count: 3))
            """#,
            macros: dataMacro)
    }
}
