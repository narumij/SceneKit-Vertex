import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation


public struct InterleaveArrayMacro { }

extension InterleaveArrayMacro: ExpressionMacro {
    
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        guard
            let type = node.genericArgumentClause?.arguments.first
        else {
            return "SceneKit_Vertex.GeometryBuilder.Source(interleave: \(raw: node.argumentList.trimmedDescription))"
        }
        
        let args = node.argumentList
        
        return "SceneKit_Vertex.GeometryBuilder.Source(interleave: (\(raw: args.map{ $0.description }.joined())) as [\(raw: type.trimmedDescription)])"
    }
}

public struct InterleaveDataMacro { }

extension InterleaveDataMacro: ExpressionMacro {
    
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        guard let type = node.genericArgumentClause?.arguments.first
        else {
            throw SCNVertexMacroError.missingGenericType
        }
        
        let args = node.argumentList
        
        return "SceneKit_Vertex.GeometryBuilder.Source(interleave: TypedData<\(raw: type.trimmedDescription)>(\(raw: args.map{ $0.description }.joined())))"
    }
}

public struct InterleaveBufferMacro { }

extension InterleaveBufferMacro: ExpressionMacro {
    
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        guard let type = node.genericArgumentClause?.arguments.first
        else { throw SCNVertexMacroError.missingGenericType }
        
        let args = node.argumentList
        
        return "SceneKit_Vertex.GeometryBuilder.Source(interleave: TypedBuffer<\(raw: type.trimmedDescription)>(\(raw: args.map{ $0.description }.joined())))"
    }
}
