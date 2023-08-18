import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation


public struct InterleaveArrayMacro { }

extension InterleaveArrayMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        let genericType = node.genericArgumentClause?.arguments.first
        
        let interleave = node.argumentList.first?.expression

        let argumentList
            = LabeledExprListSyntax(label: .interleave,
                                    expression: typedArray(genericType, interleave))
        
        return geometryBuilderSource(argumentList)
    }
}

public struct InterleaveDataMacro { }

extension InterleaveDataMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        guard let genericType = node.genericArgumentClause?.arguments.first else {
            throw SCNVertexMacroError.missingGenericType
        }
        
        let argumentList
            = LabeledExprListSyntax(label: .interleave,
                                    expression: typedData(genericType, node.argumentList))
        
        return geometryBuilderSource(argumentList)
    }
}

public struct InterleaveBufferMacro { }

extension InterleaveBufferMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        guard let genericType = node.genericArgumentClause?.arguments.first else {
            throw SCNVertexMacroError.missingGenericType
        }
        
        let argumentList = 
            LabeledExprListSyntax(label: .interleave,
                                  expression: typedBuffer(genericType, node.argumentList))
        
        return geometryBuilderSource(argumentList)
    }
}

