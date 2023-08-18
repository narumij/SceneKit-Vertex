import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ElementArrayMacro { }

extension ElementArrayMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        let genericType = node.genericArgumentClause?.arguments.first
        
        let (primitiveType, element) = node.firstAndRest(label: .primitiveType)

        guard let primitiveType else {
            throw SCNVertexMacroError.missingLabel
        }
        
        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .element, expression: typedArray(genericType,element.first?.expression))
            LabeledExprSyntax(label: .primitiveType, expression: primitiveType.expression)
        }

        return geometryBuilderElement(argumentList)
    }
}

public struct ElementDataMacro { }

extension ElementDataMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        guard let genericType = node.genericArgumentClause?.arguments.first else {
            throw SCNVertexMacroError.missingGenericType
        }
        
        let (primitiveType, element) = node.firstAndRest(label: .primitiveType)

        guard let primitiveType else {
            throw SCNVertexMacroError.missingLabel
        }

        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .element, expression: typedData(genericType,element.commaRefresh()))
            LabeledExprSyntax(label: .primitiveType, expression: primitiveType.expression)
        }

        return geometryBuilderElement(argumentList)
    }
}

public struct ElementBufferMacro { }

extension ElementBufferMacro: ExpressionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node:    some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        guard let genericType = node.genericArgumentClause?.arguments.first else {
            throw SCNVertexMacroError.missingGenericType
        }
        
        let (primitiveType, element) = node.firstAndRest(label: .primitiveType)
        
        guard let primitiveType else {
            throw SCNVertexMacroError.missingLabel
        }

        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .element, expression: typedBuffer(genericType,element.commaRefresh()))
            LabeledExprSyntax(label: .primitiveType, expression: primitiveType.expression)
        }

        return geometryBuilderElement(argumentList)
    }
}

