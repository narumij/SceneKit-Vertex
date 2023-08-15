import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SCNVertexPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        
        SCNVertexMacro.self,
        
        AttributeMacro.self,
        InterleaveAttributeMacro.self,

        SourceArrayMacro.self,
        SourceDataMacro.self,
        SourceBufferMacro.self,
        
        InterleaveArrayMacro.self,
        InterleaveDataMacro.self,
        InterleaveBufferMacro.self,
        
        ElementArrayMacro.self,
        ElementDataMacro.self,
        ElementBufferMacro.self,
        
        PolygonMacro.self,
        
        SCNGeometrySourceVerticesMacro.self,
        SCNGeometrySourceNormalsMacro.self,
        SCNGeometrySourceTexcoordsMacro.self,
    ]
}
