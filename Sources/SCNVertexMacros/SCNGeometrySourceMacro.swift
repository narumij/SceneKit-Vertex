import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct SCNGeometrySourceVerticesMacro { }

extension SCNGeometrySourceVerticesMacro: ExpressionMacro {
    
    public static func expansion<Node, Context>(of node: Node, in context: Context) throws -> SwiftSyntax.ExprSyntax where Node : SwiftSyntax.FreestandingMacroExpansionSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {
        "SCNGeometrySource(vertices: \(raw: node.argumentList.trimmedDescription))"
    }
}

public struct SCNGeometrySourceNormalsMacro { }

extension SCNGeometrySourceNormalsMacro: ExpressionMacro {
    
    public static func expansion<Node, Context>(of node: Node, in context: Context) throws -> SwiftSyntax.ExprSyntax where Node : SwiftSyntax.FreestandingMacroExpansionSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {
        "SCNGeometrySource(normals: \(raw: node.argumentList.trimmedDescription))"
    }
}

public struct SCNGeometrySourceTexcoordsMacro { }

extension SCNGeometrySourceTexcoordsMacro: ExpressionMacro {
    
    public static func expansion<Node, Context>(of node: Node, in context: Context) throws -> SwiftSyntax.ExprSyntax where Node : SwiftSyntax.FreestandingMacroExpansionSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {
        "SCNGeometrySource(textureCoordinates: \(raw: node.argumentList.trimmedDescription))"
    }
}
