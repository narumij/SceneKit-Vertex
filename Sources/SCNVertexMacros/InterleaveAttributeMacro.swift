import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct InterleaveAttributeMacro { }

extension InterleaveAttributeMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {

        let keyPath      = node.firstExpr(label: .keyPath) ?? "\\Self.\(node.macro)"
        let vertexFormat = node.firstExpr(label: .vertexFormat) ?? "nil"
        
        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .keyPath, expression: keyPath)
            LabeledExprSyntax(label: .semantic, expression: node.semantic)
            LabeledExprSyntax(label: .vertexFormat, expression: vertexFormat)
        }
        
        return interleaveAttribute(argumentList)
    }
}
