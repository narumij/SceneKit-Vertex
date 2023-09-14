import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SourceArrayMacro { }

extension SourceArrayMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        let genericType = node.genericArgumentClause?.arguments.first
        
        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .separate, expression: typedArray(genericType, "\(node.argumentList)"))
            LabeledExprSyntax(label: .semantic, expression: node.semantic)
        }

        return geometryBuilderSource(argumentList)
    }
}

public struct SourceDataMacro { }

extension SourceDataMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        guard let genericType = node.genericArgumentClause?.arguments.first else {
            throw SCNVertexMacroError.requiresGenericType(node.macro.trimmedDescription)
        }
        
        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .separate, expression: typedData(genericType,node.argumentList))
            LabeledExprSyntax(label: .semantic, expression: node.semantic)
        }

        return geometryBuilderSource(argumentList)
    }
}

public struct SourceBufferMacro { }

extension SourceBufferMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        guard let genericType = node.genericArgumentClause?.arguments.first else {
            throw SCNVertexMacroError.requiresGenericType(node.macro.trimmedDescription)
        }

        let (vertexFormat, separate) = node.firstAndRest(label: .vertexFormat)
        
        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .separate, expression: typedBuffer(genericType,separate.commaRefresh()))
            LabeledExprSyntax(label: .semantic, expression: node.semantic)
            if let vertexFormat {
                LabeledExprSyntax(label: .vertexFormat, expression: vertexFormat.expression)
            }
        }

        return geometryBuilderSource(argumentList)
    }
}
