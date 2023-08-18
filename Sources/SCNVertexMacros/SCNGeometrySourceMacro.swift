import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct SCNGeometrySourceVerticesMacro { }

extension SCNGeometrySourceVerticesMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        geometrySource(vertices: node.argumentList)
    }
}

public struct SCNGeometrySourceNormalsMacro { }

extension SCNGeometrySourceNormalsMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        geometrySource(normals: node.argumentList)
    }
}

public struct SCNGeometrySourceTexcoordsMacro { }

extension SCNGeometrySourceTexcoordsMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        geometrySource(textureCoordinates: node.argumentList)
    }
}
