import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct PolygonMacro { }

extension PolygonMacro: ExpressionMacro {
    
    public static func expansion<Node, Context>(of node: Node, in context: Context) throws -> SwiftSyntax.ExprSyntax where Node : SwiftSyntax.FreestandingMacroExpansionSyntax, Context : SwiftSyntaxMacros.MacroExpansionContext {
        "SceneKit_Vertex.GeometryBuilder.Element(polygonElement: \(raw: node.argumentList.trimmedDescription))"
    }
}
