import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SCNVertexMacros

fileprivate let arrayMacro: [String: Macro.Type] = [
    "source": SourceArrayMacro.self,
]

fileprivate let dataMacro: [String: Macro.Type] = [
    "source": SourceDataMacro.self,
]

fileprivate let bufferMacro: [String: Macro.Type] = [
    "source": SourceBufferMacro.self,
]

final class OtherTests: XCTestCase {
    
    func testSource() {
        
        assertMacroExpansion(
            #"""
            #source(v)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(separate: v, semantic: .source)
            """#,
            macros: arrayMacro)
    }
    
    func testSource0() {
        
        assertMacroExpansion(
            #"""
            #source<SIMD3<Float>>([.zero,.one])
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(separate: ([.zero, .one]) as [SIMD3<Float>], semantic: .source)
            """#,
            macros: arrayMacro)
    }
    
    func testSource1() {
        
        assertMacroExpansion(
            #"""
            #source<SIMD3<Float>>(buffer: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(separate: TypedBuffer<SIMD3<Float>>(buffer: b), semantic: .source)
            """#,
            macros: bufferMacro)
    }
    
    func testSource3() {
        
        assertMacroExpansion(
            #"""
            #source<SIMD3<Float>>(buffer: b, vertexFormat: .float3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(separate: TypedBuffer<SIMD3<Float>>(buffer: b), semantic: .source, vertexFormat: .float3)
            """#,
            macros: bufferMacro)
    }
    
    func testSource4() {
        
        assertMacroExpansion(
            #"""
            #source<SIMD3<Float>>(buffer: b, count: 3, vertexFormat: .float3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(separate: TypedBuffer<SIMD3<Float>>(buffer: b, count: 3), semantic: .source, vertexFormat: .float3)
            """#,
            macros: bufferMacro)
    }

    func testSource5() {
        
        assertMacroExpansion(
            #"""
            #source<SIMD3<Float>>(data: b)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(separate: TypedData<SIMD3<Float>>(data: b), semantic: .source)
            """#,
            macros: dataMacro)
    }
    
    func testSource7() {
        
        assertMacroExpansion(
            #"""
            #source<SIMD3<Float>>(data: b, count: 3)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.GeometryBuilder.Source(separate: TypedData<SIMD3<Float>>(data: b, count: 3), semantic: .source)
            """#,
            macros: dataMacro)
    }
}

