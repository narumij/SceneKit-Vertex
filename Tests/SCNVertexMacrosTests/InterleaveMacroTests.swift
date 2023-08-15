import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SCNVertexMacros

fileprivate let arrayMacros: [String: Macro.Type] = [
    "interleave": InterleaveArrayMacro.self,
]

fileprivate let dataMacro: [String: Macro.Type] = [
    "interleave": InterleaveDataMacro.self,
]

fileprivate let bufferMacro: [String: Macro.Type] = [
    "interleave": InterleaveBufferMacro.self,
]

final class InterleaveTests: XCTestCase {
    
    func testInterleave0() {
        
        assertMacroExpansion(
            #"""
            #interleave<MyVertex>(buffer: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(interleave: TypedBuffer<MyVertex>(buffer: b))
            """#,
            macros: bufferMacro)
    }
    
    func testInterleave1() {
        
        assertMacroExpansion(
            #"""
            #interleave<MyVertex>(buffer: b, count: 3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(interleave: TypedBuffer<MyVertex>(buffer: b, count: 3))
            """#,
            macros: bufferMacro)
    }
    
    func testInterleave2() {
        
        assertMacroExpansion(
            #"""
            #interleave<MyVertex>(data: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(interleave: TypedData<MyVertex>(data: b))
            """#,
            macros: dataMacro)
    }
    
    func testInterleave3() {
        
        assertMacroExpansion(
            #"""
            #interleave<MyVertex>(data: b, count: 3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(interleave: TypedData<MyVertex>(data: b, count: 3))
            """#,
            macros: dataMacro)
    }
    
    func testInterleave4() {
        
        assertMacroExpansion(
            #"""
            #interleave<MyVertex>(array)
            """#,
            expandedSource:
            #"""
            SceneKit_Vertex.GeometryBuilder.Source(interleave: (array) as [MyVertex])
            """#,
            macros: arrayMacros)
    }
    
    func testInterleave5() {
        
        assertMacroExpansion(
            #"""
            #interleave(array)
            """#,
            expandedSource:
            #"""
            SceneKit_Vertex.GeometryBuilder.Source(interleave: array)
            """#,
            macros: arrayMacros)
    }
}
