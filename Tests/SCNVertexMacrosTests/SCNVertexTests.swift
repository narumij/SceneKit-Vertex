import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
@testable import SCNVertexMacros

fileprivate let testMacros: [String: Macro.Type] = [
    "MTLVertex": SCNVertexMacro.self,
    "SCNAttribute": AttributeMacro.self,
    "SCNIgnore": AttributeMacro.self,
]

final class SCNVertexTests: XCTestCase {

    func test単一その1_標準的な場合() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                var vertex: SIMD3<Float> // metal
            }
            """#,
            expandedSource: #"""
            struct V {
                var vertex: SIMD3<Float> // metal
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.vertex, semantic: .vertex, vertexFormat: nil )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }
    
    func test単一その2_型がやや特殊な場合() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                var position: SIMD3<Float16> // metal
            }
            """#,
            expandedSource: #"""
            struct V {
                var position: SIMD3<Float16> // metal
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.position, semantic: .vertex, vertexFormat: nil )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }
    
    func test単一その3_位置ベクトルがない場合() throws {
        
        // SceneKitが位置ベクトルがなくても許容するので、こちらも許容する

        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                var normal: SIMD3<Float>
            }
            """#,
            expandedSource: #"""
            struct V {
                var normal: SIMD3<Float>
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.normal, semantic: .normal, vertexFormat: nil )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }
    
    func test複数その1_標準的な場合() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                var position: SIMD3<Float>
                var normal: SIMD3<Float>
            }
            """#,
            expandedSource: #"""
            struct V {
                var position: SIMD3<Float>
                var normal: SIMD3<Float>
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.position, semantic: .vertex, vertexFormat: nil ),
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.normal, semantic: .normal, vertexFormat: nil )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }
    
    func test複数その2_無視属性を利用する場合() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                var position: SIMD3<Float>
                @SCNIgnore var something: NSObject
            }
            """#,
            expandedSource: #"""
            struct V {
                var position: SIMD3<Float>
                var something: NSObject
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.position, semantic: .vertex, vertexFormat: nil )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }
    
    func test複数その3_カスタム属性を利用する場合() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                @SCNAttribute(semantic: .position, vertexFormat: .half3) var xyz: SIMD3<UInt16> // metal
                @SCNAttribute(semantic: .normal) var ijk: SIMD3<UInt16> // metal
                @SCNAttribute(semantic: .texcoord, vertexFormat: .char3) var stp: SIMD3<Int8> // metal
                @SCNIgnore var something: NSObject
            }
            """#,
            expandedSource: #"""
            struct V {
                var xyz: SIMD3<UInt16> // metal
                var ijk: SIMD3<UInt16> // metal
                var stp: SIMD3<Int8> // metal
                var something: NSObject
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.xyz, semantic: .vertex, vertexFormat: .half3 ),
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.ijk, semantic: .normal, vertexFormat: nil ),
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.stp, semantic: .texcoord, vertexFormat: .char3 )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }
    
    func test空その1() throws {
        
        // 対称のメンバーがない場合は、プロトコル適用しないことにする。

        assertMacroExpansion(
            #"""
            @MTLVertex struct V { }
            """#,
            expandedSource: #"""
            struct V { }
            """#,
            macros: testMacros)
    }
    
    func testEnumその1() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex enum V { }
            """#,
            expandedSource: #"""
            enum V { }
            """#,
            diagnostics: [.init(message: SCNVertexMacroError.notStructDeclSyntax.description, line: 1, column: 1)],
            macros: testMacros)
    }

    func testClassその1() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex class V { }
            """#,
            expandedSource: #"""
            class V { }
            """#,
            diagnostics: [.init(message: SCNVertexMacroError.notStructDeclSyntax.description, line: 1, column: 1)],
            macros: testMacros)
    }

    func testAttributeその1() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                @SCNAttribute(vertexFormat: .format) var normal: SIMD3<Short>
            }
            """#,
            expandedSource: #"""
            struct V {
                var normal: SIMD3<Short>
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.normal, semantic: .normal, vertexFormat: .format )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }
    
    func testAttributeその2() throws {
        
        assertMacroExpansion(
            #"""
            @MTLVertex struct V {
                @SCNAttribute(semantic: .normal, vertexFormat: .format) var nameless: SIMD3<Short>
            }
            """#,
            expandedSource: #"""
            struct V {
                var nameless: SIMD3<Short>
            }
            
            extension V: SceneKit_Vertex.InterleavedVertex {
                static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
                    [
                        SceneKit_Vertex.InterleaveAttribute( keyPath: \Self.nameless, semantic: .normal, vertexFormat: .format )
                    ]
                }
            }
            """#,
            macros: testMacros)
    }

}
