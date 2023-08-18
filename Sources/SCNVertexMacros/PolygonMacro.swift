import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct PolygonMacro { }

extension PolygonMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
  
        let genericType = node.genericArgumentClause?.arguments.first
        
        let polygonElement = node.argumentList.first?.expression

        let argumentList
            = LabeledExprListSyntax(label: .polygonElement,
                                    expression: typedArray(genericType, polygonElement))
        
        return geometryBuilderElement(argumentList)
    }
}
