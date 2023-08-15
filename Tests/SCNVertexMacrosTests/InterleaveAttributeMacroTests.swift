import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SCNVertexMacros

fileprivate let attributeMacro: [String: Macro.Type] = [
    "attribute": InterleaveAttributeMacro.self,
]

final class InterleaveAttributeMacroTests: XCTestCase {
    
    func testSource0() {
        
        assertMacroExpansion(
            #"""
            #attribute
            """#,
            expandedSource: #"""
            SceneKit_Vertex.InterleaveAttribute(keyPath: \Self.attribute, semantic: .attribute, vertexFormat: nil)
            """#,
            macros: attributeMacro)
    }
    
    func testSource1() {
        
        assertMacroExpansion(
            #"""
            #attribute(vertexFormat: .format)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.InterleaveAttribute(keyPath: \Self.attribute, semantic: .attribute, vertexFormat: .format)
            """#,
            macros: attributeMacro)
    }

    func testSource2() {
        
        assertMacroExpansion(
            #"""
            #attribute(keyPath: \Self.nameless, vertexFormat: .format)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.InterleaveAttribute(keyPath: \Self.nameless, semantic: .attribute, vertexFormat: .format)
            """#,
            macros: attributeMacro)
    }

    func testSource3() {
        
        assertMacroExpansion(
            #"""
            #attribute(keyPath: \Self.nameless)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.InterleaveAttribute(keyPath: \Self.nameless, semantic: .attribute, vertexFormat: nil)
            """#,
            macros: attributeMacro)
    }

#if false
    func testSource4() {
        
        assertMacroExpansion(
            #"""
            #attribute(keyPath: \.nameless, vertexFormat: .format)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.InterleaveAttribute(keyPath: \Self.nameless, semantic: .attribute, vertexFormat: .format)
            """#,
            macros: attributeMacro)
    }

    func testSource5() {
        
        assertMacroExpansion(
            #"""
            #attribute(keyPath: \.nameless)
            """#,
            expandedSource: #"""
            SceneKit_Vertex.InterleaveAttribute(keyPath: \Self.nameless, semantic: .attribute, vertexFormat: nil)
            """#,
            macros: attributeMacro)
    }
#endif
}

