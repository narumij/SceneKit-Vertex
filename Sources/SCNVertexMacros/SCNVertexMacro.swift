import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SCNVertexMacro { }

extension SCNVertexMacro: PeerMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        []
    }
}

extension SCNVertexMacro: ExtensionMacro, SCNVertexMacroCommon {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        
        guard let _ = declaration.as(StructDeclSyntax.self) else {
            throw SCNVertexMacroError.notStructDeclSyntax
        }
        
        let interleaveAttributes = declaration
            .memberBlock
            .members
            .compactMap{
                $0.decl.as(VariableDeclSyntax.self)?
                    .interleaveAttribute?
                    .with(\.leadingTrivia, .newline)
            }
        
        let ext = try ExtensionDeclSyntax("extension \(type): SceneKit_Vertex.InterleavedVertex") {
            """
            static var interleave: [SceneKit_Vertex.InterleaveAttribute] {
            \(ArrayExprSyntax(expressions: interleaveAttributes)
                .with(\.rightSquare.leadingTrivia, .newline))
            }
            """
        }
        
        return interleaveAttributes.isEmpty ? [] : [ext]
    }
}

fileprivate extension VariableDeclSyntax {
    
    var interleaveAttribute: ExprSyntax? {
        
        guard !isIgnore, !isStatic, !isComputed, let keyPath, let semantic else {
            return nil
        }
        
        let vertexFormat = vertexFormat ?? "nil"
        
        let argumentList = LabeledExprListSyntax {
            LabeledExprSyntax(label: .keyPath, expression: keyPath)
            LabeledExprSyntax(label: .semantic, expression: semantic)
            LabeledExprSyntax(label: .vertexFormat, expression: vertexFormat)
        }
        
        return SCNVertexMacro.interleaveAttribute(argumentList)
    }
    
    var pattern: PatternSyntax? {
        bindings.first?.pattern
    }
    
    var isIgnore: Bool {
        attributes.contains(attribute: .ignore)
    }

    var keyPath: ExprSyntax? {
        pattern.map{ path in "\\Self.\(path)" }
    }
    
    var semantic: ExprSyntax? {
        guard let pattern else { return nil }
        let semantic = first(attribute: .attribute, label: .semantic) ?? ".\(pattern)"
        return "\(semantic.trimmedDescription == ".position" ? ".vertex" : semantic)"
    }
    
    var vertexFormat: ExprSyntax? {
        first(attribute: .attribute, label: .vertexFormat)
    }
}
