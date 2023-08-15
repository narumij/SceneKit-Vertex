import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct ElementArrayMacro { }

extension ElementArrayMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> SwiftSyntax.ExprSyntax {
        
        guard
            let primitiveType = node.argumentList.first(where: { $0.label?.description == "primitiveType" })?.expression
        else {
            throw SCNVertexMacroError.missingLabel
        }
        
        var args = node.argumentList.filter{ $0.label?.description != "primitiveType" }
        
        guard
            let genericType = node.genericArgumentClause?.arguments.first
        else {
            return "SceneKit_Vertex.GeometryBuilder.Element(element: \(raw: args.map{ $0.description }.joined()), primitiveType: \(raw: primitiveType.trimmedDescription))"
        }

        if let l = args.last, let i = args.index(of: l) {
            args[i].trailingComma = nil
        }

        return "SceneKit_Vertex.GeometryBuilder.Element(element: (\(raw: args.map{ $0.description }.joined())) as [\(raw: genericType.trimmedDescription)], primitiveType: \(raw: primitiveType.trimmedDescription))"
    }
}

public struct ElementDataMacro { }

extension ElementDataMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> SwiftSyntax.ExprSyntax {
        
        guard
            let genericType = node.genericArgumentClause?.arguments.first
        else {
            throw SCNVertexMacroError.missingGenericType
        }
        
        guard
            let primitiveType = node.argumentList.first(where: { $0.label?.description == "primitiveType" })?.expression
        else {
            throw SCNVertexMacroError.missingLabel
        }

        var args = node.argumentList.filter{ $0.label?.description != "primitiveType" }

        if let l = args.last, let i = args.index(of: l) {
            args[i].trailingComma = nil
        }

        return "SceneKit_Vertex.GeometryBuilder.Element(element: TypedData<\(raw: genericType.trimmedDescription)>(\(raw: args.map{ $0.description }.joined())), primitiveType: \(raw: primitiveType.trimmedDescription))"
    }
}

public struct ElementBufferMacro { }

extension ElementBufferMacro: ExpressionMacro {
    
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> SwiftSyntax.ExprSyntax {
        
        guard
            let genericType = node.genericArgumentClause?.arguments.first
        else {
            throw SCNVertexMacroError.missingGenericType
        }
        
        guard
            let primitiveType = node.argumentList.first(where: { $0.label?.description == "primitiveType" })?.expression
        else {
            throw SCNVertexMacroError.missingLabel
        }

        var args = node.argumentList.filter{ $0.label?.description != "primitiveType" }

        if let l = args.last, let i = args.index(of: l) {
            args[i].trailingComma = nil
        }
        
        return "SceneKit_Vertex.GeometryBuilder.Element(element: TypedBuffer<\(raw: genericType.trimmedDescription)>(\(raw: args.map{ $0.description }.joined())), primitiveType: \(raw: primitiveType.trimmedDescription))"
    }
}
